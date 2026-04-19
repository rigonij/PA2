<?php
session_start();

if (!isset($_SESSION['logged_in']) || $_SESSION['user_role'] !== 'provider') {
    header('Location: ../public/login.php');
    exit;
}

require_once '../config/db.php';
$userId = $_SESSION['user_id'];
$successMsg = null;
$dbError = null;

//update profile 
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'update_profile') {
    $newCompany = trim($_POST['company_name']);
    $newPhone = trim($_POST['phone_number']);
    
    if (!empty($newCompany) && !empty($newPhone)) {
        try {
            //transaction because we are updating two different tables
            $bdd->beginTransaction();
            $stmtUser = $bdd->prepare("UPDATE USER SET Phone_Number = :phone WHERE Id_USER = :id");
            $stmtUser->execute([':phone' => $newPhone, ':id' => $userId]);

            $stmtProv = $bdd->prepare("UPDATE PROVIDER SET Company_Name = :company, Validation_Status = 0 WHERE Id_USER = :id");
            $stmtProv->execute([':company' => $newCompany, ':id' => $userId]);

            $bdd->commit();
            $successMsg = "Profil mis à jour. Votre compte est de nouveau en attente de vérification.";
        } catch (Exception $e) {
            $bdd->rollBack();
            $dbError = "Erreur de mise à jour : " . $e->getMessage();
        }
    } else {
        $dbError = "Veuillez remplir tous les champs obligatoires.";
    }
}


try {
    $stmtInfo = $bdd->prepare("
        SELECT u.Email, u.Phone_Number, p.Company_Name, p.Provider_Description, p.Validation_Status
        FROM USER u
        JOIN PROVIDER p ON u.Id_USER = p.Id_USER
        WHERE u.Id_USER = :id
    ");
    $stmtInfo->execute([':id' => $userId]);
    $providerInfo = $stmtInfo->fetch(PDO::FETCH_ASSOC);
    $stmtCount = $bdd->prepare("
        SELECT COUNT(*) as ActiveCount
        FROM QUALIFY
        WHERE Id_USER = :id AND Is_Active = 1
    ");
    $stmtCount->execute([':id' => $userId]);
    $activeCount = $stmtCount->fetchColumn();

} catch (Exception $e) {
    die("Erreur de base de données : " . $e->getMessage());
}

require_once '../templates/provider/provider_dashboard_view.php';
?>