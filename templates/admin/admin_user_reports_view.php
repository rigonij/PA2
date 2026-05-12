<?php
$pageTitle = "SilverHappy • Signalements";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$reports = $reports ?? [];
$loadError = $loadError ?? "";
$flashSuccess = $flashSuccess ?? "";
$flashError = $flashError ?? "";
$activeStatus = $activeStatus ?? "pending";

$counts = ["pending" => 0, "resolved" => 0, "dismissed" => 0];
foreach ($reports as $r) {
    $s = $r["status"] ?? "pending";
    if (isset($counts[$s])) $counts[$s]++;
}

$filtered = array_values(array_filter($reports, function ($r) use ($activeStatus) {
    return ($r["status"] ?? "pending") === $activeStatus;
}));

$fmt = function ($iso) {
    if (empty($iso)) return "";
    try {
        $d = new DateTime($iso);
        $d->setTimezone(new DateTimeZone("Europe/Paris"));
        return $d->format("d/m/Y H:i");
    } catch (Exception $e) {
        return htmlspecialchars($iso);
    }
};
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <h1 class="h4 fw-bold mb-1">Signalements d'utilisateurs</h1>
                <p class="text-secondary mb-0">Liste des signalements remontés par les utilisateurs.</p>
            </div>
            <a href="admin_dashboard.php" class="btn btn-outline-secondary btn-sm">Retour</a>
        </div>
    </div>

    <?php if (!empty($flashSuccess)): ?>
        <div class="alert alert-success"><?= htmlspecialchars($flashSuccess) ?></div>
    <?php endif; ?>
    <?php if (!empty($flashError)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($flashError) ?></div>
    <?php endif; ?>
    <?php if (!empty($loadError)): ?>
        <div class="alert alert-warning"><?= htmlspecialchars($loadError) ?></div>
    <?php endif; ?>

    <div class="sh-card p-3 mb-3">
        <ul class="nav nav-pills gap-2">
            <li class="nav-item">
                <a class="nav-link <?= $activeStatus === 'pending' ? 'active' : '' ?>" href="admin_user_reports.php?status=pending">
                    En attente <span class="badge bg-secondary ms-1"><?= $counts["pending"] ?></span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?= $activeStatus === 'resolved' ? 'active' : '' ?>" href="admin_user_reports.php?status=resolved">
                    Traités <span class="badge bg-secondary ms-1"><?= $counts["resolved"] ?></span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?= $activeStatus === 'dismissed' ? 'active' : '' ?>" href="admin_user_reports.php?status=dismissed">
                    Rejetés <span class="badge bg-secondary ms-1"><?= $counts["dismissed"] ?></span>
                </a>
            </li>
        </ul>
    </div>

    <div class="sh-card p-3">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Signalé par</th>
                        <th>Utilisateur signalé</th>
                        <th>Raison</th>
                        <th>Statut</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (empty($filtered)): ?>
                        <tr>
                            <td colspan="6" class="text-secondary text-center py-4">Aucun signalement dans cette catégorie.</td>
                        </tr>
                    <?php else: ?>
                        <?php foreach ($filtered as $r): ?>
                            <?php
                            $reporterName = trim(($r["reporter_prenom"] ?? "") . " " . ($r["reporter_nom"] ?? ""));
                            if ($reporterName === "") $reporterName = $r["reporter_email"] ?? "—";
                            $reportedName = trim(($r["reported_prenom"] ?? "") . " " . ($r["reported_nom"] ?? ""));
                            if ($reportedName === "") $reportedName = $r["reported_email"] ?? "—";
                            $status = $r["status"] ?? "pending";
                            $badgeClass = $status === "pending" ? "bg-warning text-dark" : ($status === "resolved" ? "bg-success" : "bg-secondary");
                            $badgeLabel = $status === "pending" ? "En attente" : ($status === "resolved" ? "Traité" : "Rejeté");
                            $reportedId = (int)($r["reported_id"] ?? 0);
                            $reportId = (int)($r["id"] ?? 0);
                            $reasonAttr = htmlspecialchars($r["reason"] ?? "", ENT_QUOTES);
                            ?>
                            <tr>
                                <td><?= $fmt($r["created_at"] ?? "") ?></td>
                                <td>
                                    <div class="fw-bold"><?= htmlspecialchars($reporterName) ?></div>
                                    <div class="small text-secondary"><?= htmlspecialchars($r["reporter_email"] ?? "") ?></div>
                                </td>
                                <td>
                                    <div class="fw-bold"><?= htmlspecialchars($reportedName) ?></div>
                                    <div class="small text-secondary"><?= htmlspecialchars($r["reported_email"] ?? "") ?></div>
                                </td>
                                <td style="max-width:320px;">
                                    <?php $reasonText = (string)($r["reason"] ?? ""); $reasonShort = mb_strimwidth($reasonText, 0, 25, "..."); ?>
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="text-truncate flex-grow-1"><?= htmlspecialchars($reasonShort) ?></span>
                                        <?php if (mb_strlen($reasonText) > 25): ?>
                                            <button type="button" class="btn btn-sm btn-outline-secondary detail-btn flex-shrink-0" data-detail-title="Raison du signalement" data-detail-text="<?= htmlspecialchars($reasonText, ENT_QUOTES) ?>">Détails</button>
                                        <?php endif; ?>
                                    </div>
                                </td>
                                <td><span class="badge <?= $badgeClass ?>"><?= $badgeLabel ?></span></td>
                                <td class="text-end">
                                    <?php if ($status === "pending" && $reportId > 0): ?>
                                        <button class="btn btn-sm btn-outline-warning me-1 warn-btn" data-report-id="<?= $reportId ?>" data-reason="<?= $reasonAttr ?>">Avertir</button>
                                        <button class="btn btn-sm btn-outline-secondary me-1 dismiss-btn" data-report-id="<?= $reportId ?>">Rejeter</button>
                                    <?php endif; ?>
                                    <?php if ($reportedId > 0): ?>
                                        <a href="admin_user_sanctions.php?id=<?= $reportedId ?>" class="btn btn-sm btn-outline-primary">Voir le casier</a>
                                    <?php else: ?>
                                        <span class="text-secondary small">—</span>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
(function() {
    async function callResolve(reportId, action, reason) {
        const r = await fetch("admin_user_reports.php?api=1", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ report_id: reportId, action: action, reason: reason || "" })
        });
        return r.json();
    }

    document.querySelectorAll(".warn-btn").forEach(function(b) {
        b.addEventListener("click", async function() {
            const defaultReason = b.dataset.reason || "Comportement signalé";
            const reason = prompt("Raison de l'avertissement :", defaultReason);
            if (reason === null) return;
            if (!reason.trim()) { alert("Raison obligatoire"); return; }
            const j = await callResolve(parseInt(b.dataset.reportId), "warning", reason.trim());
            if (!j.success) { alert(j.message || "Erreur"); return; }
            location.reload();
        });
    });

    document.querySelectorAll(".dismiss-btn").forEach(function(b) {
        b.addEventListener("click", async function() {
            if (!confirm("Rejeter ce signalement ?")) return;
            const j = await callResolve(parseInt(b.dataset.reportId), "dismiss", "");
            if (!j.success) { alert(j.message || "Erreur"); return; }
            location.reload();
        });
    });
})();
</script>

<?php
include __DIR__ . "/../common/footer-scripts.php";
?>

<div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detailModalTitle">Détails</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
            </div>
            <div class="modal-body" id="detailModalBody" style="white-space:pre-wrap; word-break:break-word;"></div>
        </div>
    </div>
</div>
<script>
document.addEventListener("click", function(e) {
    const b = e.target.closest(".detail-btn");
    if (!b) return;
    document.getElementById("detailModalTitle").textContent = b.dataset.detailTitle || "Détails";
    document.getElementById("detailModalBody").textContent = b.dataset.detailText || "";
    bootstrap.Modal.getOrCreateInstance(document.getElementById("detailModal")).show();
});
</script>
