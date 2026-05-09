<?php
$pageTitle = "SilverHappy • Mes RDV médicaux";
$isSeniorUi = true;
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$flashSuccess = $flashSuccess ?? "";
$flashError = $flashError ?? "";
$medicals = $medicals ?? [];
$accountAddress = $accountAddress ?? "";
?>

<div class="container py-4">
    <?php include __DIR__ . "/../common/topbar.php"; ?>

    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/../common/sidebar.php"; ?>
        </div>

        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Mes RDV médicaux</h1>
                <p class="text-secondary mb-0">Planifie tes rendez-vous avec un prestataire Santé.</p>
            </div>

            <?php if (!empty($flashSuccess)): ?>
                <div class="alert alert-success"><?= htmlspecialchars($flashSuccess) ?></div>
            <?php endif; ?>

            <?php if (!empty($flashError)): ?>
                <div class="alert alert-danger"><?= htmlspecialchars($flashError) ?></div>
            <?php endif; ?>

            <div class="sh-card p-4 mb-3">
                <h2 class="h5 mb-3">Nouveau RDV</h2>

                <form method="POST" action="rdv-medicaux.php">
                    <input type="hidden" name="action" value="create">

                    <div class="mb-3">
                        <label class="form-label">Date et heure</label>
                        <input type="datetime-local" class="form-control" name="start_at" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Prestataire Santé</label>
                        <select class="form-select" name="provider_id" id="medicalProviderSelect" required>
                            <option value="">Chargement...</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Lieu</label>
                        <?php if (!empty($accountAddress)): ?>
                            <input type="text" class="form-control" value="<?= htmlspecialchars($accountAddress) ?>" disabled>
                            <input type="hidden" name="use_account_address" value="1">
                            <input type="hidden" name="location" value="">
                            <div class="form-text">Adresse de ton compte. Pour la modifier, va dans Profil.</div>
                        <?php else: ?>
                            <input type="text" class="form-control" name="location" required>
                            <div class="form-text">Aucune adresse enregistrée sur ton compte. Saisis le lieu du RDV.</div>
                        <?php endif; ?>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Détails (optionnel)</label>
                        <textarea class="form-control" name="details" rows="3"></textarea>
                    </div>

                    <button type="submit" class="btn btn-sh-gold">Créer le RDV</button>
                </form>
            </div>

            <div class="sh-card p-4 mb-3">
                <h2 class="h5 mb-3">Mes RDV</h2>

                <?php if (empty($medicals)): ?>
                    <div class="text-secondary">Aucun RDV pour le moment.</div>
                <?php else: ?>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Docteur</th>
                                    <th>Lieu</th>
                                    <th>Détails</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($medicals as $m): ?>
                                    <?php
                                    $mid = (int)($m["id"] ?? 0);
                                    $startAt = $m["start_at"] ?? "";
                                    $dateFr = $startAt ? fmt_dt($startAt) : "";
                                    $doctorName = $m["doctor_name"] ?? "";
                                    $location = $m["location"] ?? "";
                                    $details = $m["details"] ?? "";
                                    ?>
                                    <tr>
                                        <td><?= htmlspecialchars($dateFr) ?></td>
                                        <td><?= htmlspecialchars($doctorName) ?></td>
                                        <td><?= htmlspecialchars($location) ?: "—" ?></td>
                                        <td class="text-secondary small"><?= htmlspecialchars($details) ?: "—" ?></td>
                                        <td class="text-end">
                                            <form method="POST" action="rdv-medicaux.php" class="d-inline" onsubmit="return confirm('Supprimer ce RDV ?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="medical_id" value="<?= $mid ?>">
                                                <button type="submit" class="btn btn-outline-danger btn-sm">Supprimer</button>
                                            </form>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const select = document.getElementById("medicalProviderSelect");
        if (!select) return;

        fetch("api_medical_doctors.php")
            .then(function(r) {
                return r.json();
            })
            .then(function(data) {
                select.innerHTML = "";

                if (!data || !data.success || !Array.isArray(data.doctors) || data.doctors.length === 0) {
                    const opt = document.createElement("option");
                    opt.value = "";
                    opt.textContent = "Aucun prestataire disponible";
                    select.appendChild(opt);
                    return;
                }

                const placeholder = document.createElement("option");
                placeholder.value = "";
                placeholder.textContent = "Choisir un prestataire";
                select.appendChild(placeholder);

                data.doctors.forEach(function(d) {
                    const opt = document.createElement("option");
                    opt.value = d.provider_id;
                    const label = d.label || d.company_name || ("Prestataire " + d.provider_id);
                    opt.textContent = label;
                    select.appendChild(opt);
                });
            })
            .catch(function() {
                select.innerHTML = "";
                const opt = document.createElement("option");
                opt.value = "";
                opt.textContent = "Erreur de chargement";
                select.appendChild(opt);
            });
    });
</script>

<?php
include __DIR__ . "/../common/footer.php";
include __DIR__ . "/../common/footer-scripts.php";
?>