<?php
$pageTitle = "Prestataire • Horaires du service";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$selectedMap = [];
foreach (($selectedIds ?? []) as $sid) {
    $selectedMap[(int)$sid] = true;
}

function dayLabel($dow)
{
    $dow = (int)$dow;
    $labels = [
        1 => "Lundi",
        2 => "Mardi",
        3 => "Mercredi",
        4 => "Jeudi",
        5 => "Vendredi",
        6 => "Samedi",
        7 => "Dimanche",
    ];
    return $labels[$dow] ?? ("Jour " . $dow);
}
?>

<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Horaires du service</h1>
            <p class="text-secondary mb-0">Coche les créneaux où ce service est disponible.</p>
        </div>
        <a class="btn btn-outline-secondary" href="provider_services.php">← Retour</a>
    </div>

    <?php if (!empty($error)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <?php if (!empty($success)): ?>
        <div class="alert alert-success"><?= htmlspecialchars($success) ?></div>
    <?php endif; ?>

    <form method="POST">
        <div class="sh-card p-4">
            <?php
            $lastDow = null;
            if (!empty($schedules)):
                foreach ($schedules as $sc):
                    $id = (int)($sc["id"] ?? 0);
                    $dow = (int)($sc["day_of_week"] ?? 0);
                    $start = $sc["start_time"] ?? "";
                    $end = $sc["end_time"] ?? "";
                    $checked = !empty($selectedMap[$id]);

                    if ($lastDow !== $dow):
                        if ($lastDow !== null) echo "<hr>";
                        echo '<h2 class="h6 fw-bold mb-2">' . htmlspecialchars(dayLabel($dow)) . '</h2>';
                        $lastDow = $dow;
                    endif;
            ?>
                    <div class="form-check mb-2">
                        <input class="form-check-input"
                            type="checkbox"
                            name="schedule_ids[]"
                            id="sid<?= $id ?>"
                            value="<?= $id ?>"
                            <?= $checked ? "checked" : "" ?>>

                        <label class="form-check-label" for="sid<?= $id ?>">
                            <?= htmlspecialchars($start) ?> → <?= htmlspecialchars($end) ?>
                            <span class="text-secondary">(#<?= $id ?>)</span>
                        </label>
                    </div>
                <?php
                endforeach;
            else:
                ?>
                <p class="text-secondary mb-0">
                    Aucun créneau trouvé. Ajoute d’abord des horaires dans tes disponibilités (provider_schedule).
                </p>
            <?php endif; ?>
        </div>

        <div class="d-flex justify-content-end mt-3">
            <button class="btn btn-primary" type="submit">Enregistrer</button>
        </div>
    </form>
</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>