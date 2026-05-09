<?php
$pageTitle = "SilverHappy • Prestataire • Planning";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$upcoming = [];
$history = [];
foreach ($items as $it) {
    $section = $it["section"] ?? "historique";
    if ($section === "a_venir") $upcoming[] = $it;
    else $history[] = $it;
}
usort($upcoming, function ($a, $b) {
    return strcmp($a["start_at"] ?? "", $b["start_at"] ?? "");
});

function sh_render_planning_table(array $items, string $emptyText): void
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
                    <th>Début</th>
                    <th>Service</th>
                    <th>Senior</th>
                    <th>Ville</th>
                    <th>Statut</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($items as $it):
                    $id            = (int)($it["id"] ?? 0);
                    $startPretty   = $it["start_pretty"] ?? ($it["start_at"] ?? "");
                    $endPretty     = $it["end_pretty"] ?? ($it["end_at"] ?? "");
                    $serviceName   = $it["service_name"] ?? "";
                    $seniorNom     = $it["senior_nom"] ?? "";
                    $seniorPrenom  = $it["senior_prenom"] ?? "";
                    $seniorEmail   = $it["senior_email"] ?? "";
                    $seniorName    = trim($seniorPrenom . " " . $seniorNom);
                    if ($seniorName === "") $seniorName = $seniorEmail;
                    $city          = $it["address_city"] ?? ($it["city"] ?? "");
                    $street        = $it["address_street"] ?? "";
                    $postal        = $it["address_postal"] ?? "";
                    $country       = $it["address_country"] ?? "";
                    $status        = $it["status"] ?? "";
                    $comment       = $it["comment"] ?? "";

                    if ($status === "Canceled") {
                        $statusLabel = "Annulé par le senior";
                        $statusBadge = "text-bg-danger";
                    } elseif ($status === "Accepted") {
                        $statusLabel = "Confirmé";
                        $statusBadge = "text-bg-success";
                    } else {
                        $statusLabel = $status;
                        $statusBadge = "text-bg-secondary";
                    }

                    $payload = json_encode([
                        "id"          => $id,
                        "start"       => $startPretty,
                        "end"         => $endPretty,
                        "service"     => $serviceName,
                        "senior"      => $seniorName,
                        "email"       => $seniorEmail,
                        "street"      => $street,
                        "postal"      => $postal,
                        "city"        => $city,
                        "country"     => $country,
                        "comment"     => $comment,
                        "statusLabel" => $statusLabel,
                    ], JSON_UNESCAPED_UNICODE | JSON_HEX_APOS | JSON_HEX_QUOT);
                ?>
                    <tr>
                        <td><?= htmlspecialchars(fmt_dt($it["start_at"] ?? "")) ?></td>
                        <td><?= htmlspecialchars($serviceName ?: "N/A") ?></td>
                        <td><?= htmlspecialchars($seniorName ?: "N/A") ?></td>
                        <td><?= htmlspecialchars($city ?: "N/A") ?></td>
                        <td><span class="badge <?= $statusBadge ?>"><?= htmlspecialchars($statusLabel) ?></span></td>
                        <td class="text-end">
                            <button type="button" class="btn btn-outline-primary btn-sm"
                                onclick='showPlanningDetails(<?= $payload ?>)'>
                                Détails
                            </button>
                        </td>
                    </tr>
                <?php endforeach; ?>
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
                <h1 class="h4 mb-1">Planning</h1>
                <p class="text-secondary mb-0">Vos interventions à venir.</p>
            </div>

            <?php if (!empty($error)): ?>
                <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
            <?php endif; ?>

            <div class="sh-card p-4 mb-3">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <h2 class="h5 mb-0">
                        À venir
                        <?php if (!empty($upcoming)): ?>
                            <span class="badge text-bg-success ms-1"><?= count($upcoming) ?></span>
                        <?php endif; ?>
                    </h2>
                </div>
                <?php sh_render_planning_table($upcoming, "Aucune intervention à venir."); ?>
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
                                <form method="POST" action="provider_planning.php"
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
                        <?php sh_render_planning_table($history, "Aucune intervention passée."); ?>
                    </div>
                </details>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="planningDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Détails de l'intervention</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <dl class="row mb-0">
                    <dt class="col-sm-4">Statut</dt>
                    <dd class="col-sm-8" id="pdm_status">—</dd>
                    <dt class="col-sm-4">Début</dt>
                    <dd class="col-sm-8" id="pdm_start">—</dd>
                    <dt class="col-sm-4">Fin</dt>
                    <dd class="col-sm-8" id="pdm_end">—</dd>
                    <dt class="col-sm-4">Service</dt>
                    <dd class="col-sm-8" id="pdm_service">—</dd>
                    <dt class="col-sm-4">Senior</dt>
                    <dd class="col-sm-8" id="pdm_senior">—</dd>
                    <dt class="col-sm-4">Email</dt>
                    <dd class="col-sm-8" id="pdm_email">—</dd>
                    <dt class="col-sm-4">Adresse</dt>
                    <dd class="col-sm-8" id="pdm_address">—</dd>
                    <dt class="col-sm-4">Message du senior</dt>
                    <dd class="col-sm-8" id="pdm_comment">—</dd>
                </dl>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<script>
    function showPlanningDetails(d) {
        function set(id, val) {
            var el = document.getElementById(id);
            el.textContent = (val && String(val).trim() !== "") ? val : "—";
        }
        set("pdm_status", d.statusLabel);
        set("pdm_start", d.start);
        set("pdm_end", d.end);
        set("pdm_service", d.service);
        set("pdm_senior", d.senior);
        set("pdm_email", d.email);
        var addrParts = [d.street, [d.postal, d.city].filter(Boolean).join(" ")].filter(function(x) {
            return x && String(x).trim() !== "";
        });
        set("pdm_address", addrParts.join(", "));
        set("pdm_comment", d.comment);
        var modal = new bootstrap.Modal(document.getElementById("planningDetailsModal"));
        modal.show();
    }
</script>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>