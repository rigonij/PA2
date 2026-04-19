<?php
session_start();

if (!isset($_SESSION['logged_in']) || $_SESSION['user_role'] !== 'provider') {
    header('Location: ../public/login.php');
    exit;
}

require_once '../config/db.php';

$userId = $_SESSION['user_id'];
$todayInterventions = [];
$futureInterventions = [];

try {
    $stmt = $bdd->prepare("
        SELECT i.Id_INTERVENTION, i.Date_Start, i.Date_End, i.Status, u.Email AS Senior_Email
        FROM INTERVENTION i
        JOIN USER u ON i.Id_SENIOR = u.Id_USER
        WHERE i.Id_PROVIDER = :provider_id AND DATE(i.Date_Start) >= CURDATE()
        ORDER BY i.Date_Start ASC
    ");
    $stmt->execute([':provider_id' => $userId]);
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);


    $currentDate = date('Y-m-d');
    foreach ($results as $row) {
        $interventionDate = date('Y-m-d', strtotime($row['Date_Start']));
        if ($interventionDate === $currentDate) {
            $todayInterventions[] = $row;
        } else {
            $futureInterventions[] = $row;
        }
    }
} catch (Exception $e) {
    die("Erreur de base de données : " . $e->getMessage());
}

require_once '../templates/provider/provider_planning_view.php';
?>