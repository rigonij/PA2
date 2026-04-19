<?php
session_start();

if (!isset($_SESSION['logged_in']) || $_SESSION['user_role'] !== 'provider') {
    header('Location: ../public/login.php');
    exit;
}

require_once '../config/db.php';

$userId = $_SESSION['user_id'];
$dbError = null;
$successMsg = null;
$services = [];
$catalogServices = [];

// buttun add 
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'add_service') {
    /*
    $idServiceType = (int)($_POST['id_service_type'] ?? 0);
    $customTitle = trim($_POST['custom_title'] ?? '');
    $price = (float)($_POST['negotiated_price'] ?? 0);
    $experience = (int)($_POST['experience_years'] ?? 0);
    */
    
    $idServiceType =  0;
    $customTitle = '';
    $price = 0 ;
    $experience = 0;

    if ($idServiceType > 0 && $price >= 0 && $experience >= 0) {
        try {
            $stmtInsert = $bdd->prepare("
                INSERT INTO QUALIFY (Id_USER, Id_SERVICE_TYPE, Custom_Title, Negotiated_Price, Experience_Years, Is_Active)
                VALUES (:user, :service, :title, :price, :exp, 1)
            ");
            $stmtInsert->execute([
                ':user' => $userId,
                ':service' => $idServiceType,
                ':title' => $customTitle ?: null,
                ':price' => $price,
                ':exp' => $experience
            ]);
            $successMsg = "Le service a été ajouté à votre profil avec succès.";
        } catch (PDOException $e) {
            if ($e->getCode() == 23000) {
                $dbError = "Vous proposez déjà ce hashtag. Modifiez le service existant.";
            } else {
                $dbError = "Erreur SQL : " . $e->getMessage();
            }
        }
    } else {
        $dbError = "Veuillez remplir correctement les champs obligatoires.";
    }
}

// button modifier 
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'edit_service') {
    $idServiceType = (int)($_POST['edit_id_service_type'] ?? 0);
    $customTitle = trim($_POST['edit_custom_title'] ?? '');
    $price = (float)($_POST['edit_negotiated_price'] ?? 0);
    $experience = (int)($_POST['edit_experience_years'] ?? 0);
    $isActive = isset($_POST['edit_is_active']) ? 1 : 0;

    if ($idServiceType > 0 && $price >= 0 && $experience >= 0) {
        try {
            $stmtUpdate = $bdd->prepare("
                UPDATE QUALIFY 
                SET Custom_Title = :title, Negotiated_Price = :price, Experience_Years = :exp, Is_Active = :active
                WHERE Id_USER = :user AND Id_SERVICE_TYPE = :service
            ");
            $stmtUpdate->execute([
                ':title' => $customTitle ?: null,
                ':price' => $price,
                ':exp' => $experience,
                ':active' => $isActive,
                ':user' => $userId,
                ':service' => $idServiceType
            ]);
            $successMsg = "Le service a été mis à jour avec succès.";
        } catch (PDOException $e) {
            $dbError = "Erreur SQL lors de la modification : " . $e->getMessage();
        }
    } else {
        $dbError = "Données invalides pour la modification.";
    }
}

// CURRENT SERVICES
try {
    $sql = "SELECT 
                st.Id_SERVICE_TYPE,
                st.Name, 
                c.Name AS Category, 
                q.Custom_Title,
                q.Negotiated_Price AS Price, 
                q.Experience_Years,
                q.Is_Active 
            FROM QUALIFY q
            INNER JOIN SERVICE_TYPE st ON q.Id_SERVICE_TYPE = st.Id_SERVICE_TYPE
            INNER JOIN CATEGORY c ON st.Id_CATEGORY = c.Id_CATEGORY
            WHERE q.Id_USER = :id";
            
    $stmt = $bdd->prepare($sql);
    $stmt->execute([':id' => $userId]);
    $services = $stmt->fetchAll(PDO::FETCH_ASSOC);

    //for js 
    $stmtCatalog = $bdd->prepare("
        SELECT st.Id_SERVICE_TYPE, st.Name, c.Name AS Category 
        FROM SERVICE_TYPE st
        INNER JOIN CATEGORY c ON st.Id_CATEGORY = c.Id_CATEGORY
        WHERE st.Id_SERVICE_TYPE NOT IN (
            SELECT Id_SERVICE_TYPE FROM QUALIFY WHERE Id_USER = :id
        )
        ORDER BY c.Name, st.Name
    ");
    $stmtCatalog->execute([':id' => $userId]);
    $catalogServices = $stmtCatalog->fetchAll(PDO::FETCH_ASSOC);

} catch (Exception $e) {
    if (!$dbError) {
        $dbError = "Erreur base de données : " . $e->getMessage();
    }
}

// Extract unique cattegories for the first dropdown, if not do this is not good . you nknow t'ias capter 
$uniqueCategories = array_unique(array_column($catalogServices, 'Category'));

require_once '../templates/provider/provider_services_view.php';
?>