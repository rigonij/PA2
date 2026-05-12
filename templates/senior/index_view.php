<?php
$pageTitle = "SilverHappy • Accueil";
$isSeniorUi = true;
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$userName = $userName ?? "";
?>

<div class="container py-4">
    <?php include __DIR__ . "/../common/topbar.php"; ?>

    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/../common/sidebar.php"; ?>
        </div>

        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Accueil</h1>
                <p class="text-secondary mb-0">Bonjour, <?= htmlspecialchars($userName) ?>.</p>
            </div>

            <div class="row g-3">
                <div class="col-md-6">
                    <div class="sh-card p-3">
                        <div class="fw-bold mb-2">Raccourcis</div>
                        <div class="d-flex flex-wrap gap-2">
                            <a class="btn btn-sh-primary" href="prestations.php">Voir les services</a>
                            <a class="btn btn-outline-secondary" href="planning.php">Planning</a>
                            <a class="btn btn-outline-secondary" href="devis.php">Devis</a>
                            <a class="btn btn-outline-secondary" href="facturation.php">Factures</a>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="sh-card p-3">
                        <div class="fw-bold mb-2">État du compte</div>
                        <?php
                $stApiBase = "http://backend:8080";
                $stToken   = $_SESSION["token"] ?? "";
                $stSub = null;
                if ($stToken) {
                    $stCh = curl_init($stApiBase . "/api/senior/subscription");
                    curl_setopt($stCh, CURLOPT_RETURNTRANSFER, true);
                    curl_setopt($stCh, CURLOPT_HTTPHEADER, ["X-Token: " . $stToken]);
                    $stResp = curl_exec($stCh);
                    curl_close($stCh);
                    $stData = json_decode((string)$stResp, true);
                    if (!empty($stData["has_subscription"])) $stSub = $stData;
                }
                ?>
                <ul class="mb-0 text-secondary">
                    <li>Abonnement : <?php if ($stSub && !empty($stSub["is_active"])): ?><?= htmlspecialchars($stSub["name"] ?? "Actif") ?><?php if (!empty($stSub["end_date"])): ?> &middot; Renouvellement le <?= htmlspecialchars($stSub["end_date"]) ?><?php endif; ?><?php else: ?>Aucun abonnement actif<?php endif; ?></li>
                </ul>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>