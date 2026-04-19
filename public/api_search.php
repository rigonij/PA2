<?php

session_start();
require_once '../config/db.php';

$query = isset($_GET['query_search_bar']) ? trim($_GET['query_search_bar']) : '';

$sql = "SELECT c.Name AS CategoryName, s.Name AS ServiceName, s.link_img, p.Company_Name, u.Id_USER
        FROM SERVICE_TYPE s
        JOIN QUALIFY q ON s.Id_SERVICE_TYPE = q.Id_SERVICE_TYPE
        JOIN PROVIDER p ON q.Id_USER = p.Id_USER
        JOIN USER u ON p.Id_USER = u.Id_USER
        JOIN CATEGORY c ON s.Id_CATEGORY = c.Id_CATEGORY
        WHERE p.Validation_Status = 1 ";

$params = [];

if (!empty($query)) {
    $sql = $sql . " AND (s.Name LIKE :query_bar OR p.Company_Name LIKE :query_bar OR c.Name LIKE :query_bar)";
    $params[':query_bar'] = "%$query%";
}
$sql .= " ORDER BY c.Name";


$prepare = $bdd->prepare($sql);
$prepare->execute($params);
$results = $prepare->fetchAll(PDO::FETCH_ASSOC);

$categories = [];
foreach ($results as $row) {
    $cateName = $row['CategoryName'];
    $categories[$cateName][] = $row;
}


header('Content-Type: application/json');
echo json_encode($categories);
exit;
