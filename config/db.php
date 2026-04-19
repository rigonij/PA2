<?php

try {
    $bdd = new PDO(
        'mysql:host=localhost;dbname=projet_annuel;charset=utf8mb4',
        'root',
        '',
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
} catch (Exception $e) {
    die('Erreur PDO : ' . $e->getMessage());
}
