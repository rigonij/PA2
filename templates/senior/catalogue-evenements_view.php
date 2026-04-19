<?php
$pageTitle = "SilverHappy • Événements";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
?>
<div class="container py-4">
    <?php include __DIR__ . "/../common/topbar.php"; ?>
    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/../common/sidebar.php"; ?>
        </div>
        <div class="col-lg-9">

            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Catalogue • Événements</h1>
            </div>

            <?php if (!empty($errorMsg)): ?>
                <div class="alert alert-danger"><?= htmlspecialchars($errorMsg) ?></div>
            <?php endif; ?>

            <?php if ($statusEvent === "success"): ?>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    Inscription confirmée ! Votre paiement a bien été reçu.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($statusEvent === "cancel"): ?>
                <div class="alert alert-warning alert-dismissible fade show" role="alert">
                    Paiement annulé. Vous n'avez pas été inscrit à l'événement.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($statusEvent === "error"): ?>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    Une erreur est survenue lors du paiement. Veuillez réessayer.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php endif; ?>

            <div class="row g-3">
                <?php foreach ($events as $e): ?>
                    <?php
                    $id     = (int)($e["id"] ?? 0);
                    $isPaid = !empty($e["is_paid"]);
                    $isReg  = !empty($e["is_registered"]);
                    $price  = (int)($e["price"] ?? 0);
                    $priceLabel = $isPaid
                        ? number_format($price / 100, 2, ',', ' ') . ' €'
                        : 'Gratuit';
                    ?>
                    <div class="col-md-6">
                        <div class="sh-card p-3">

                            <div class="fw-bold"><?= htmlspecialchars($e["title"] ?? "") ?></div>

                            <div class="text-secondary">
                                <?= htmlspecialchars(date("d/m/Y H:i", strtotime($e["event_date"] ?? ""))) ?>
                                • <?= htmlspecialchars($e["location"] ?? "") ?>
                            </div>

                            <div class="mt-2 d-flex gap-2 flex-wrap">
                                <?php if (!empty($e["max_participants"])): ?>
                                    <span class="badge badge-sh">Max: <?= (int)$e["max_participants"] ?></span>
                                <?php endif; ?>

                                <?php if ($isPaid): ?>
                                    <span class="badge text-bg-warning"><?= $priceLabel ?></span>
                                <?php else: ?>
                                    <span class="badge text-bg-success">Gratuit</span>
                                <?php endif; ?>

                                <?php if ($isReg): ?>
                                    <span class="badge text-bg-success">Inscrit</span>
                                <?php else: ?>
                                    <span class="badge text-bg-secondary">Non inscrit</span>
                                <?php endif; ?>
                            </div>

                            <div class="mt-3 d-flex gap-2">
                                <?php if ($isReg): ?>
                                    <a class="btn btn-outline-danger"
                                        href="catalogue-evenements.php?action=unsubscribe&id=<?= $id ?>">
                                        Se désinscrire
                                    </a>
                                <?php elseif ($isPaid): ?>
                                    <a class="btn btn-sh-gold"
                                        href="catalogue-evenements.php?action=pay_event&id=<?= $id ?>">
                                        Payer (<?= $priceLabel ?>)
                                    </a>
                                <?php else: ?>
                                    <a class="btn btn-sh-gold"
                                        href="catalogue-evenements.php?action=subscribe&id=<?= $id ?>">
                                        S'inscrire
                                    </a>
                                <?php endif; ?>

                                <button class="btn btn-outline-secondary" type="button"
                                    onclick="alert('Détails (à faire)')">Détails</button>
                            </div>

                        </div>
                    </div>
                <?php endforeach; ?>

                <?php if (empty($events)): ?>
                    <div class="col-12">
                        <div class="text-secondary">Aucun événement disponible.</div>
                    </div>
                <?php endif; ?>
            </div>

        </div>
    </div>
</div>
<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>