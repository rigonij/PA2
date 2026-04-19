<?php
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Back office Silver Happy - Tableau de bord</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        p{
            font-size: 1.5rem;
            padding: 0.5rem;
        }
        .main{
            display: flex;
            min-height: 100vh;
        }
        .BarreLat{
            flex: 1 1 0;
            max-width: 280px;
            padding: 2rem 1rem;
            background-color: #000;
        }
        .BarreLat h3{
            font-size : 0.75rem;
            text-transform: uppercase;
            margin-bottom: 0.5rem;
            color: #fff;
        }
        .BarreLat .menu{
            margin: 0 -1rem;
        }
        .BarreLat .menu .item{
            display: block;
            padding: 1rem;
            color: white;
            text-decoration: none;
            transition: 0.3s linear;
        }
        .BarreLat .menu .item:hover,
        .BarreLat .menu .item.actif {
            color: lightgreen;
            border-right: 5px solid lightgreen;
        }
        .menu-toggle{
            display: none;
            position: fixed;
            top: 2rem;
            right: 2rem;
            width: 60px;
            height:60px;
            border-radius: 99px;
            background-color: rgb(0, 0, 0);
            cursor: pointer;
            z-index: 1000;
        }
        .hamburger span {
            display: block;
            width: 30px;
            height: 4px;
            margin: 6px 0;
            background-color: #fff;
        }
        @media (max-width: 1024px){
            .BarreLat{
                max-width: 240px;
            }
        }
        @media(max-width: 768px){
            .menu-toggle{
                display: block;
            }
            .main{
                padding-top: 4rem;
            }
            .BarreLat{
                position:fixed;
                top: 0;
                left: -260px;
                height: 100vh;
                width: 100%;
                max-width: 260px;
                transition: 0.2s linear;
                z-index: 900;
            }
            .BarreLat.open{
                left: 0;
            }
        }
    </style>
</head>
<body>
<div class="menu-toggle">
    <div class="hamburger">
        <span></span>
        <span></span>
        <span></span>
    </div>
</div>
<div class="main">
    <aside class="BarreLat">
        <div class="container">
            <h3>Menu</h3>
            <nav class="menu">
                <a href="dashboard.php" class="item actif">Accueil</a>
                <a href="gestion_users.php" class="item">Comptes</a>
                <a href="#" class="item">Prestataires</a>
                <a href="#" class="item">Seniors</a>
                <a href="#" class="item">Interventions</a>
                <a href="#" class="item">Événements</a>
                <a href="index.php?route=admin_logout" class="item">Déconnexion</a>
            </nav>
        </div>
    </aside>

    <div class="container py-4">
        <h1 class="py-2">Bienvenue dans le back office Silver Happy</h1>
        <div class="row g-3 py-3">
            <div class="col-md-4">
                <div class="card text-bg-light">
                    <div class="card-body">
                        <h5 class="card-title">Utilisateurs</h5>
                        <p class="card-text mb-0">Total : <?= (int)($stats['total_users'] ?? 0) ?></p>
                        <p class="card-text mb-0">Seniors : <?= (int)($stats['total_seniors'] ?? 0) ?></p>
                        <p class="card-text mb-0">Prestataires : <?= (int)($stats['total_providers'] ?? 0) ?></p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-bg-light">
                    <div class="card-body">
                        <h5 class="card-title">Prestataires</h5>
                        <p class="card-text mb-0">En attente de validation : <?= (int)($stats['pending_providers'] ?? 0) ?></p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-bg-light">
                    <div class="card-body">
                        <h5 class="card-title">Activité</h5>
                        <p class="card-text mb-0">Interventions en attente : <?= (int)($stats['pending_intervention'] ?? 0) ?></p>
                        <p class="card-text mb-0">Événements à venir : <?= (int)($stats['upcoming_events'] ?? 0) ?></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const toggle = document.querySelector('.menu-toggle');
        const menu = document.querySelector('.BarreLat');
        if (toggle && menu) {
            toggle.addEventListener('click', function () {
                menu.classList.toggle('open');
            });
        }
    });
</script>
</body>
</html>
