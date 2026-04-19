<?php
$pageTitle = "SilverHappy • RDV médicaux";
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
                <h1 class="h4 mb-1">Rendez-vous médicaux</h1>
            </div>

            <div class="row g-3">
                <div class="col-md-6">
                    <div class="sh-card p-4">
                        <div class="fw-bold mb-2">Prendre un RDV</div>

                        <form method="POST" action="rdv-medicaux.php" class="d-grid gap-3">
                            <input type="hidden" name="action" value="create_medical">

                            <div>
                                <label class="form-label">Date & heure</label>
                                <input type="datetime-local" class="form-control" name="start_at" required>
                            </div>

                            <div>
                                <label class="form-label">Nom du docteur</label>
                                <input class="form-control" name="doctor_name" placeholder="Ex: Dr Martin" required>
                            </div>

                            <div>
                                <label class="form-label">Lieu</label>
                                <input class="form-control" name="location" placeholder="Ex: Paris 11" required>
                            </div>

                            <div>
                                <label class="form-label">Détails (confidentiel)</label>
                                <textarea class="form-control" name="details" rows="3" placeholder="Motif, notes..."></textarea>
                                <div class="form-text">Dans la vraie version, ce champ serait chiffré côté back.</div>
                            </div>

                            <button class="btn btn-sh-primary" type="submit">Créer</button>
                        </form>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="sh-card p-4">
                        <div class="fw-bold mb-2">Mes RDV</div>

                        <?php if (empty($medicalItems)): ?>
                            <div class="text-secondary">Aucun rendez-vous pour le moment.</div>
                        <?php else: ?>
                            <div class="d-grid gap-2">
                                <?php foreach ($medicalItems as $m): ?>
                                    <?php
                                    $id = (int)($m["id"] ?? 0);
                                    $startAt = $m["start_at"] ?? "";
                                    $dateLabel = $startAt ? date("d/m/Y H:i", strtotime($startAt)) : "";
                                    $doctor = $m["doctor_name"] ?? "";
                                    $location = $m["location"] ?? "";
                                    $details = $m["details"] ?? "";
                                    ?>
                                    <div class="p-3 border rounded-3 bg-white">
                                        <div class="d-flex justify-content-between gap-2">
                                            <div>
                                                <div class="fw-bold"><?= htmlspecialchars($dateLabel) ?></div>
                                                <div class="text-secondary"><?= htmlspecialchars($doctor) ?> • <?= htmlspecialchars($location) ?></div>
                                            </div>
                                            <div class="text-end">
                                                <a class="btn btn-outline-danger btn-sm"
                                                    href="rdv-medicaux.php?action=delete&id=<?= $id ?>"
                                                    onclick="return confirm('Supprimer ce RDV ?');">
                                                    Supprimer
                                                </a>
                                            </div>
                                        </div>

                                        <?php if (!empty($details)): ?>
                                            <div class="mt-2">
                                                <button class="btn btn-outline-secondary btn-sm" type="button"
                                                    onclick="alert(<?= json_encode($details) ?>)">
                                                    Voir détails
                                                </button>
                                            </div>
                                        <?php endif; ?>
                                    </div>
                                <?php endforeach; ?>
                            </div>

                            <div class="text-secondary small mt-2">
                                Les RDV apparaissent aussi dans votre planning.
                            </div>
                        <?php endif; ?>
                    </div>
                </div>

            </div>

        </div>
    </div>
</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>