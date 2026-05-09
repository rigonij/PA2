<?php
$pageTitle = "SilverHappy • Mes RDV médicaux";
$isSeniorUi = true;
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$events = $events ?? [];
$services = $services ?? [];
$medicals = $medicals ?? [];

function fmt_dt_fr($iso)
{
    if (empty($iso)) return "";
    try {
        $tz = new DateTimeZone("Europe/Paris");
        $d = new DateTime($iso, $tz);
        $d->setTimezone($tz);
        return $d->format("d/m/Y H:i");
    } catch (Exception $e) {
        return htmlspecialchars($iso);
    }
}

function service_status_label($status, $adminApproved, $providerApproved)
{
    if ($status === "Canceled") return ["Annulé", "text-bg-danger"];
    if ($status === "Refused") return ["Refusé", "text-bg-danger"];
    if ($status === "Accepted" || $providerApproved == 1) return ["Confirmé", "text-bg-success"];
    return ["En attente du prestataire", "text-bg-warning"];
}

$isHistory = ($scope ?? "upcoming") === "history";
?>
<div class="container py-4">
    <?php include __DIR__ . "/../common/topbar.php"; ?>

    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/../common/sidebar.php"; ?>
        </div>
        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                    <div>
                        <h1 class="h4 mb-1">Mon planning</h1>
                        <p class="text-secondary mb-0">
                            <?= $isHistory ? "Historique de vos événements, services et RDV passés." : "Événements, services et RDV à venir." ?>
                        </p>
                    </div>
                    <div class="btn-group" role="group">
                        <a href="planning.php?scope=upcoming" class="btn <?= !$isHistory ? "btn-sh-primary" : "btn-outline-secondary" ?>">À venir</a>
                        <a href="planning.php?scope=history" class="btn <?= $isHistory ? "btn-sh-primary" : "btn-outline-secondary" ?>">Historique</a>
                    </div>
                </div>
                <?php if ($isHistory && (count($events) + count($services) + count($medicals)) > 0): ?>
                    <div class="mt-3">
                        <a href="planning.php?action=clear_history"
                            class="btn btn-outline-danger btn-sm"
                            onclick="return confirm('Vider tout l\'historique du planning ?');">
                            Vider l'historique
                        </a>
                    </div>
                <?php endif; ?>
            </div>

            <div class="sh-card p-4 mb-3">
                <h2 class="h5 mb-3">Événements</h2>
                <?php if (empty($events)): ?>
                    <div class="text-secondary">Aucun événement <?= $isHistory ? "passé" : "à venir" ?>.</div>
                <?php else: ?>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Titre</th>
                                    <th>Lieu</th>
                                    <?php if (!$isHistory): ?><th></th><?php endif; ?>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($events as $e): ?>
                                    <tr>
                                        <td><?= htmlspecialchars(fmt_dt_fr($e["start_at"] ?? "")) ?></td>
                                        <td><?= htmlspecialchars($e["title"] ?? "") ?></td>
                                        <td><?= htmlspecialchars($e["location"] ?? "") ?: "—" ?></td>
                                        <?php if (!$isHistory): ?>
                                            <td class="text-end">
                                                <a class="btn btn-outline-danger btn-sm"
                                                    href="planning.php?action=unsubscribe_event&id=<?= (int)($e["ref_id"] ?? 0) ?>"
                                                    onclick="return confirm('Se désinscrire de cet événement ?');">Annuler</a>
                                            </td>
                                        <?php endif; ?>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                <?php endif; ?>
            </div>

            <div class="sh-card p-4 mb-3">
                <h2 class="h5 mb-3">Services</h2>
                <?php if (empty($services)): ?>
                    <div class="text-secondary">Aucun service <?= $isHistory ? "passé" : "à venir" ?>.</div>
                <?php else: ?>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Service</th>
                                    <th>Lieu</th>
                                    <th>Statut</th>
                                    <?php if (!$isHistory): ?><th></th><?php endif; ?>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($services as $s):
                                    [$lbl, $cls] = service_status_label(
                                        $s["status"] ?? "",
                                        (int)($s["admin_approved"] ?? 0),
                                        (int)($s["provider_approved"] ?? 0)
                                    );
                                ?>
                                    <tr>
                                        <td><?= htmlspecialchars(fmt_dt_fr($s["start_at"] ?? "")) ?></td>
                                        <td><?= htmlspecialchars($s["title"] ?? "") ?></td>
                                        <td><?= htmlspecialchars($s["location"] ?? "") ?: "—" ?></td>
                                        <td><span class="badge <?= $cls ?>"><?= htmlspecialchars($lbl) ?></span></td>
                                        <?php if (!$isHistory): ?>
                                            <td class="text-end">
                                                <a class="btn btn-outline-danger btn-sm"
                                                    href="planning.php?action=unreserve_service&id=<?= (int)($s["ref_id"] ?? 0) ?>"
                                                    onclick="return confirm('Annuler cette réservation ?');">Annuler</a>
                                            </td>
                                        <?php endif; ?>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                <?php endif; ?>
            </div>

            <div class="sh-card p-4 mb-3">
                <h2 class="h5 mb-3">RDV médicaux</h2>
                <?php if (empty($medicals)): ?>
                    <div class="text-secondary">Aucun RDV médical <?= $isHistory ? "passé" : "à venir" ?>.</div>
                <?php else: ?>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Titre</th>
                                    <th>Lieu</th>
                                    <th>Détails</th>
                                    <?php if (!$isHistory): ?><th></th><?php endif; ?>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($medicals as $m): ?>
                                    <tr>
                                        <td><?= htmlspecialchars(fmt_dt_fr($m["start_at"] ?? "")) ?></td>
                                        <td><?= htmlspecialchars($m["title"] ?? "") ?></td>
                                        <td><?= htmlspecialchars($m["location"] ?? "") ?: "—" ?></td>
                                        <td class="text-secondary small"><?= htmlspecialchars($m["details"] ?? "") ?: "—" ?></td>
                                        <?php if (!$isHistory): ?>
                                            <td class="text-end">
                                                <a class="btn btn-outline-danger btn-sm"
                                                    href="planning.php?action=delete_medical&id=<?= (int)($m["ref_id"] ?? 0) ?>"
                                                    onclick="return confirm('Supprimer ce RDV ?');">Supprimer</a>
                                            </td>
                                        <?php endif; ?>
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
<?php
include __DIR__ . "/../common/footer.php";
include __DIR__ . "/../common/footer-scripts.php";
?>