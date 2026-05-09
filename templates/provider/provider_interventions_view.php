<?php
$pageTitle = "SilverHappy • Mes interventions";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$newOnes = [];
$accepted = [];
$history = [];
$interventions = $interventions ?? [];

foreach ($interventions as $it) {
    $section = $it["section"] ?? "historique";
    if ($section === "nouvelle") $newOnes[] = $it;
    elseif ($section === "acceptee") $accepted[] = $it;
    else $history[] = $it;
}

function sh_render_intervention_row(array $it, bool $allowActions): void
{
    $id              = (int)($it["id"] ?? 0);
    $dateStart       = $it["date_start"] ?? "";
    $status          = $it["status"] ?? "";
    $adminApproved   = (int)($it["admin_approved"] ?? 0);
    $providerApproved = (int)($it["provider_approved"] ?? 0);
    $serviceName     = $it["service_name"] ?? "";
    $seniorName      = trim(($it["senior_prenom"] ?? "") . " " . ($it["senior_nom"] ?? ""));
    $seniorId        = (int)($it["senior_id"] ?? 0);
    $comment         = $it["comment"] ?? "";
    $isNew           = !empty($it["is_new"]);

    if ($status === "Canceled") {
        $statusLabel = "Annulé par le senior";
        $statusBadge = "text-bg-danger";
    } elseif ($status === "Refused") {
        $statusLabel = "Refusé";
        $statusBadge = "text-bg-danger";
    } elseif ($status === "Accepted" || $providerApproved === 1) {
        $statusLabel = "Confirmé";
        $statusBadge = "text-bg-success";
    } else {
        $statusLabel = "En attente de votre validation";
        $statusBadge = "text-bg-warning";
    }
?>
    <tr<?= $isNew ? ' class="table-warning"' : '' ?>>
        <td>
            <?= htmlspecialchars(fmt_dt($dateStart)) ?>
            <?php if ($isNew): ?>
                <span class="badge text-bg-warning ms-1">Nouveau</span>
            <?php endif; ?>
        </td>
        <td><?= htmlspecialchars($serviceName) ?></td>
        <td><?= htmlspecialchars($seniorName) ?></td>
        <td class="text-secondary small"><?= htmlspecialchars($comment) ?: "—" ?></td>
        <td>
            <span class="badge <?= $statusBadge ?>">
                <?= htmlspecialchars($statusLabel) ?>
            </span>
        </td>
        <td class="text-end">
            <?php if ($allowActions): ?>
                <form method="POST" action="provider_interventions.php"
                    class="d-inline"
                    onsubmit="return confirm('Accepter cette intervention ?');">
                    <input type="hidden" name="action" value="approve">
                    <input type="hidden" name="intervention_id" value="<?= $id ?>">
                    <button type="submit" class="btn btn-success btn-sm">Accepter</button>
                </form>
                <form method="POST" action="provider_interventions.php"
                    class="d-inline ms-1"
                    onsubmit="return confirm('Refuser cette intervention ? Elle sera supprimée.');">
                    <input type="hidden" name="action" value="refuse">
                    <input type="hidden" name="intervention_id" value="<?= $id ?>">
                    <button type="submit" class="btn btn-outline-danger btn-sm">Refuser</button>
                </form>
            <?php else: ?>
                <span class="text-secondary small">—</span>
            <?php endif; ?>
            <button class="btn btn-outline-secondary btn-sm"
                onclick="openSeniorDetailModal(<?= $seniorId ?>)">
                Détails
            </button>
            <button class="btn btn-outline-danger btn-sm"
                onclick="openReportUserModal(<?= $seniorId ?>, '<?= htmlspecialchars(addslashes($seniorName)) ?>')">
                <i class="bi bi-flag"></i>
            </button>
        </td>
        </tr>
    <?php
}

function sh_render_intervention_table(array $items, bool $allowActions, string $emptyText): void
{
    if (empty($items)) {
        echo '<div class="text-secondary">' . htmlspecialchars($emptyText) . '</div>';
        return;
    }
    ?>
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Service</th>
                        <th>Senior</th>
                        <th>Commentaire</th>
                        <th>Statut</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($items as $it) sh_render_intervention_row($it, $allowActions); ?>
                </tbody>
            </table>
        </div>
    <?php
}
    ?>
    <div class="container py-4">
        <?php include __DIR__ . "/partials/topbar.php"; ?>
        <div class="row g-3">
            <div class="col-lg-3">
                <?php include __DIR__ . "/partials/sidebar.php"; ?>
            </div>

            <div class="col-lg-9">
                <div class="sh-card p-4 mb-3">
                    <h1 class="h4 mb-1">Mes interventions</h1>
                    <p class="text-secondary mb-0">Réservations faites par les seniors pour vos services.</p>
                </div>

                <div class="sh-card p-4 mb-3">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h2 class="h5 mb-0">
                            Nouvelles demandes
                            <?php if (!empty($newOnes)): ?>
                                <span class="badge text-bg-warning ms-1"><?= count($newOnes) ?></span>
                            <?php endif; ?>
                        </h2>
                    </div>
                    <?php sh_render_intervention_table($newOnes, true, "Aucune nouvelle demande."); ?>
                </div>

                <div class="sh-card p-4 mb-3">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h2 class="h5 mb-0">
                            Acceptées / à venir
                            <?php if (!empty($accepted)): ?>
                                <span class="badge text-bg-success ms-1"><?= count($accepted) ?></span>
                            <?php endif; ?>
                        </h2>
                    </div>
                    <?php sh_render_intervention_table($accepted, false, "Aucune intervention à venir."); ?>
                </div>

                <div class="sh-card p-4">
                    <details>
                        <summary style="cursor:pointer; list-style:none;">
                            <div class="d-flex align-items-center justify-content-between">
                                <h2 class="h5 mb-0">
                                    Historique
                                    <?php if (!empty($history)): ?>
                                        <span class="badge text-bg-secondary ms-1"><?= count($history) ?></span>
                                    <?php endif; ?>
                                </h2>
                                <?php if (!empty($history)): ?>
                                    <form method="POST" action="provider_interventions.php"
                                        onsubmit="return confirm('Vider tout l\'historique ? Cette action est irréversible.');"
                                        onclick="event.stopPropagation();">
                                        <input type="hidden" name="action" value="clear_history">
                                        <button type="submit" class="btn btn-outline-danger btn-sm">
                                            Vider l'historique
                                        </button>
                                    </form>
                                <?php endif; ?>
                            </div>
                        </summary>
                        <div class="mt-3">
                            <?php sh_render_intervention_table($history, false, "Aucune intervention passée."); ?>
                        </div>
                    </details>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="seniorDetailModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Informations du senior</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="seniorDetailLoading" class="text-secondary">Chargement...</div>
                    <div id="seniorDetailContent" style="display:none;">
                        <p class="mb-2"><strong>Nom :</strong> <span id="sdName"></span></p>
                        <p class="mb-2"><strong>Email :</strong> <span id="sdEmail"></span></p>
                        <p class="mb-2"><strong>Téléphone :</strong> <span id="sdPhone"></span></p>
                        <p class="mb-0"><strong>Adresse :</strong><br><span id="sdAddress"></span></p>
                    </div>
                    <div id="seniorDetailError" class="text-danger" style="display:none;"></div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        window.openSeniorDetailModal = async function(seniorId) {
            const loading = document.getElementById("seniorDetailLoading");
            const content = document.getElementById("seniorDetailContent");
            const errorEl = document.getElementById("seniorDetailError");

            loading.style.display = "block";
            content.style.display = "none";
            errorEl.style.display = "none";

            const modal = new bootstrap.Modal(document.getElementById("seniorDetailModal"));
            modal.show();

            try {
                const r = await fetch("api_senior_info.php?id=" + seniorId);
                const j = await r.json();

                loading.style.display = "none";

                if (!j.success || !j.senior) {
                    errorEl.textContent = j.message || "Erreur lors du chargement";
                    errorEl.style.display = "block";
                    return;
                }

                const s = j.senior;
                const fullName = ((s.prenom || "") + " " + (s.nom || "")).trim() || "—";
                const email = s.email || "—";
                const phone = s.phone_number || "—";

                let address = "";
                if (s.address_street) address += s.address_street;
                const cityZip = ((s.address_zip || "") + " " + (s.address_city || "")).trim();
                if (cityZip) address += (address ? "<br>" : "") + cityZip;
                if (!address) address = "Aucune adresse renseignée";

                document.getElementById("sdName").textContent = fullName;
                document.getElementById("sdEmail").textContent = email;
                document.getElementById("sdPhone").textContent = phone;
                document.getElementById("sdAddress").innerHTML = address;

                content.style.display = "block";
            } catch (e) {
                loading.style.display = "none";
                errorEl.textContent = "Erreur réseau";
                errorEl.style.display = "block";
            }
        };
    </script>

    <?php include __DIR__ . "/../common/report_user_modal.php"; ?>
    <?php include __DIR__ . "/../common/footer.php"; ?>
    <?php include __DIR__ . "/../common/footer-scripts.php"; ?>