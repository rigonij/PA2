<?php $pageTitle = "SilverHappy • Abonnement";
$isSeniorUi = true;
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php"; ?>

<div class="container py-4">
    <?php include __DIR__ . "/../common/topbar.php"; ?>
    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/../common/sidebar.php"; ?>
        </div>
        <div class="col-lg-9">
            <?php if ($status === "success"): ?>
                <div class="alert alert-success">Abonnement activé avec succès !</div>
            <?php elseif ($status === "cancel"): ?>
                <div class="alert alert-warning">Paiement annulé.</div>
            <?php endif; ?>

            <?php if (!empty($error)): ?>
                <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
            <?php endif; ?>

            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Abonnement & renouvellement</h1>
            </div>

            <div class="row g-3">
                <div class="col-md-6">
                    <div class="sh-card p-4">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <div class="fw-bold">Abonnement actuel</div>
                            <?php
                            $isActive = !empty($subscription) && ($subscription["status"] ?? "") === "Actif";
                            ?>
                            <?php if ($isActive): ?>
                                <span class="badge text-bg-success">Actif</span>
                            <?php else: ?>
                                <span class="badge text-bg-secondary">Inactif</span>
                            <?php endif; ?>
                        </div>

                        <?php if (!empty($subscription) && !empty($subscription["name"])): ?>
                            <ul class="text-secondary mb-3">
                                <li>Type : <?= htmlspecialchars($subscription["name"]) ?></li>
                                <?php if ($subscription["is_renewal"] ?? false): ?>
                                    <li>Tarif renouvellement</li>
                                <?php endif; ?>
                                <?php if (!empty($subscription["end_date"])): ?>
                                    <li>Renouvellement : <?= htmlspecialchars($subscription["end_date"]) ?></li>
                                <?php endif; ?>
                            </ul>
                        <?php else: ?>
                            <p class="text-secondary mb-3">Aucun abonnement actif.</p>
                        <?php endif; ?>

                        <div class="d-flex flex-column gap-2">
                            <div class="fw-semibold small text-secondary mb-1">Abonnement normal :</div>
                            <form method="POST">
                                <input type="hidden" name="plan" value="monthly_normal">
                                <button class="btn btn-sh-gold w-100">4 €/mois</button>
                            </form>
                            <form method="POST">
                                <input type="hidden" name="plan" value="yearly_normal">
                                <button class="btn btn-outline-warning w-100">40 €/an</button>
                            </form>
                            <div class="fw-semibold small text-secondary mb-1 mt-2">Renouvellement :</div>
                            <form method="POST">
                                <input type="hidden" name="plan" value="monthly_renewal">
                                <button class="btn btn-sh-gold w-100">3 €/mois</button>
                            </form>
                            <form method="POST">
                                <input type="hidden" name="plan" value="yearly_renewal">
                                <button class="btn btn-outline-warning w-100">35 €/an</button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="sh-card p-4">
                        <div class="fw-bold mb-2">Historique des paiements</div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Type</th>
                                        <th>Montant</th>
                                        <th>Statut</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if (empty($payments)): ?>
                                        <tr>
                                            <td colspan="4" class="text-secondary text-center">Aucun paiement.</td>
                                        </tr>
                                    <?php else: ?>
                                        <?php foreach ($payments as $p): ?>
                                            <tr>
                                                <td><?= htmlspecialchars($p["date"]) ?></td>
                                                <td><?= htmlspecialchars($p["type_label"]) ?></td>
                                                <td><?= number_format($p["amount_euros"], 2, ",", " ") ?> €</td>
                                                <td><span class="badge text-bg-success">Payé</span></td>
                                            </tr>
                                        <?php endforeach; ?>
                                    <?php endif; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>