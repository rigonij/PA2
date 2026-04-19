<?php
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Back office Silver Happy - Gestion des prestataires</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
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
                <a href="gestion_users.php" class="item actif">Comptes</a>
                <a href="gestion_provider.php" class="item">Prestataires</a>
                <a href="gestion_seniors.php" class="item">Seniors</a>
                <a href="#" class="item">Interventions</a>
                <a href="#" class="item">Événements</a>
                <a href="index.php?route=admin_logout" class="item">Déconnexion</a>
            </nav>
        </div>
    </aside>

    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1>Gestion des prestataires</h1>
            <a href="#" class="btn btn-success disabled" aria-disabled="true">Créer un compte (à venir)</a>
        </div>

        <table class="table table-dark table-striped">
            <thead>
            <tr>
                <th scope="col">ID</th>
                <th scope="col">Email</th>
                <th scope="col">Ville</th>
                <th scope="col">Type</th>
                <th scope="col">Actions</th>
            </tr>
            </thead>
            <tbody>
            <?php if (!empty($users)): ?>
                <?php foreach ($users as $user): ?>
                    <tr>
                        <td><?= htmlspecialchars($user['Id_USER']) ?></td>
                        <td><?= htmlspecialchars($user['Email']) ?></td>
                        <td><?= htmlspecialchars($user['Address_City'] ?? '') ?></td>
                        <td><?= htmlspecialchars($user['user_type']) ?></td>
                        <td>
                            <button class="btn btn-sm btn-primary" disabled>Voir / éditer</button>
                            <button class="btn btn-sm btn-danger" disabled>Supprimer</button>
                        </td>
                    </tr>
                <?php endforeach; ?>
            <?php else: ?>
                <tr>
                    <td colspan="5" class="text-center">Aucun utilisateur trouvé.</td>
                </tr>
            <?php endif; ?>
            </tbody>
        </table>
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