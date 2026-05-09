<?php
$pageTitle = "Admin • Casier utilisateur";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$sanctions = $sanctions ?? [];
$userInfo = $userInfo ?? ["nom" => "", "prenom" => "", "email" => ""];
$warningCount = $warningCount ?? 0;
$banCount = $banCount ?? 0;
$loadError = $loadError ?? "";

$activeBan = null;
foreach ($sanctions as $s) {
    if (!empty($s["is_active"]) && in_array($s["type"], ["ban_temp", "ban_perm"])) {
        $activeBan = $s;
        break;
    }
}
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Casier de <?= htmlspecialchars(($userInfo["prenom"] ?? "") . " " . ($userInfo["nom"] ?? "")) ?></h1>
            <p class="text-secondary mb-0"><?= htmlspecialchars($userInfo["email"] ?? "") ?></p>
        </div>
        <a class="btn btn-outline-secondary" href="admin_user_reports.php">← Retour</a>
    </div>

    <?php if (!empty($loadError)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($loadError) ?></div>
    <?php endif; ?>

    <div class="mb-3">
        <div class="sh-card p-4">
            <div class="d-flex flex-wrap gap-2">
                <span class="badge text-bg-warning">Avertissements : <?= (int)$warningCount ?> / 3</span>
                <span class="badge text-bg-danger">Bannissements : <?= (int)$banCount ?> / 3</span>
                <?php if ($activeBan): ?>
                    <?php if ($activeBan["type"] === "ban_perm"): ?>
                        <span class="badge text-bg-dark">Banni à vie</span>
                    <?php else: ?>
                        <span class="badge text-bg-danger">Suspendu jusqu'au <?= date("d/m/Y H:i", strtotime($activeBan["banned_until"])) ?></span>
                    <?php endif; ?>
                <?php else: ?>
                    <span class="badge text-bg-success">Compte actif</span>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <div class="mb-4">
        <h2 class="h5 fw-bold mb-2">Compteurs</h2>
        <div class="sh-card p-3">
            <div class="row g-3">
                <div class="col-md-4 col-sm-6">
                    <div class="sh-card p-3 text-center">
                        <div class="text-muted small mb-1">Avertissements</div>
                        <div class="fw-bold fs-4"><?= (int)$warningCount ?></div>
                        <div class="text-muted small">Seuil ban auto : 3</div>
                    </div>
                </div>
                <div class="col-md-4 col-sm-6">
                    <div class="sh-card p-3 text-center">
                        <div class="text-muted small mb-1">Bannissements</div>
                        <div class="fw-bold fs-4"><?= (int)$banCount ?></div>
                        <div class="text-muted small">Seuil ban à vie auto : 3</div>
                    </div>
                </div>
                <div class="col-md-4 col-sm-6">
                    <div class="sh-card p-3 text-center">
                        <div class="text-muted small mb-1">Total sanctions</div>
                        <div class="fw-bold fs-4"><?= count($sanctions) ?></div>
                        <div class="text-muted small">Toutes confondues</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="mb-4">
        <h2 class="h5 fw-bold mb-2">Historique</h2>
        <div class="sh-card p-3">
            <?php if (empty($sanctions)): ?>
                <div class="text-secondary text-center py-4">Aucune sanction.</div>
            <?php else: ?>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Type</th>
                                <th>Raison</th>
                                <th>Source</th>
                                <th>Lu ?</th>
                                <th>Statut</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($sanctions as $s): ?>
                                <tr>
                                    <td><small><?= date("d/m/Y H:i", strtotime($s["created_at"])) ?></small></td>
                                    <td>
                                        <?php
                                        $typeBadge = ["warning" => "warning", "ban_temp" => "danger", "ban_perm" => "dark"][$s["type"]] ?? "secondary";
                                        $typeLabel = ["warning" => "Avertissement", "ban_temp" => "Suspension", "ban_perm" => "Ban définitif"][$s["type"]] ?? $s["type"];
                                        ?>
                                        <span class="badge text-bg-<?= $typeBadge ?>"><?= $typeLabel ?></span>
                                        <?php if ($s["type"] === "ban_temp" && isset($s["banned_until"])): ?>
                                            <div class="text-muted small">Jusqu'au <?= date("d/m/Y H:i", strtotime($s["banned_until"])) ?></div>
                                        <?php endif; ?>
                                    </td>
                                    <td><?= nl2br(htmlspecialchars($s["reason"])) ?></td>
                                    <td>
                                        <?php
                                        $srcLabel = [
                                            "manual" => "Admin",
                                            "auto_warning_threshold" => "Auto (3 warns)",
                                            "auto_ban_threshold" => "Auto (3 bans)"
                                        ][$s["source"]] ?? $s["source"];
                                        ?>
                                        <small><?= $srcLabel ?></small>
                                    </td>
                                    <td>
                                        <?php if (!empty($s["acknowledged"])): ?>
                                            <span class="badge text-bg-success">Lu</span>
                                            <?php if (isset($s["acknowledged_at"])): ?>
                                                <div class="text-muted small"><?= date("d/m/Y H:i", strtotime($s["acknowledged_at"])) ?></div>
                                            <?php endif; ?>
                                        <?php else: ?>
                                            <span class="badge text-bg-secondary">Non lu</span>
                                        <?php endif; ?>
                                    </td>
                                    <td>
                                        <?php if (!empty($s["is_active"])): ?>
                                            <span class="badge text-bg-danger">Actif</span>
                                        <?php else: ?>
                                            <span class="badge text-bg-light text-dark">Expiré</span>
                                        <?php endif; ?>
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

<?php include __DIR__ . "/../common/footer-scripts.php"; ?>