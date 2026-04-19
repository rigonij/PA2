<?php
$pageTitle = "SilverHappy • Prestataire • Disponibilités";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$days = [
    1 => "Lundi",
    2 => "Mardi",
    3 => "Mercredi",
    4 => "Jeudi",
    5 => "Vendredi",
    6 => "Samedi",
    7 => "Dimanche",
];
?>

<div class="container py-4">
    <?php include __DIR__ . "/partials/topbar.php"; ?>

    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/partials/sidebar.php"; ?>
        </div>

        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Mes disponibilités</h1>
                <p class="text-secondary mb-0">Créneaux hebdomadaires + absences ponctuelles.</p>
            </div>

            <?php if (!empty($error)): ?>
                <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
            <?php endif; ?>
            <?php if (!empty($success)): ?>
                <div class="alert alert-success"><?= htmlspecialchars($success) ?></div>
            <?php endif; ?>

            <div class="row g-3">
                <div class="col-12">
                    <div class="sh-card p-4">
                        <div class="fw-bold mb-3">Ajouter un créneau hebdomadaire</div>

                        <form method="POST" class="row g-2 align-items-end">
                            <input type="hidden" name="action" value="add_schedule">

                            <div class="col-md-4">
                                <label class="form-label">Jour</label>
                                <select name="day_of_week" class="form-select" required>
                                    <?php foreach ($days as $k => $label): ?>
                                        <option value="<?= (int)$k ?>"><?= htmlspecialchars($label) ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Début</label>
                                <input type="time" name="start_time" class="form-control" required>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Fin</label>
                                <input type="time" name="end_time" class="form-control" required>
                            </div>

                            <div class="col-md-2 d-grid">
                                <button class="btn btn-sh-gold" type="submit">Ajouter</button>
                            </div>
                        </form>

                        <hr>

                        <div class="fw-bold mb-2">Mes créneaux</div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Jour</th>
                                        <th>Début</th>
                                        <th>Fin</th>
                                        <th style="width: 1%;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if (!empty($schedules)): ?>
                                        <?php foreach ($schedules as $s): ?>
                                            <?php
                                            $dow = (int)($s["day_of_week"] ?? 0);
                                            $start = $s["start_time"] ?? "";
                                            $end = $s["end_time"] ?? "";
                                            ?>
                                            <tr>
                                                <td><?= htmlspecialchars($days[$dow] ?? "N/A") ?></td>
                                                <td><?= htmlspecialchars(substr($start, 0, 5)) ?></td>
                                                <td><?= htmlspecialchars(substr($end, 0, 5)) ?></td>
                                                <td>
                                                    <form method="POST" onsubmit="return confirm('Supprimer ce créneau ?');">
                                                        <input type="hidden" name="action" value="delete_schedule">
                                                        <input type="hidden" name="id" value="<?= (int)($s["id"] ?? 0) ?>">
                                                        <button class="btn btn-outline-danger btn-sm" type="submit">Supprimer</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        <?php endforeach; ?>
                                    <?php else: ?>
                                        <tr>
                                            <td colspan="4" class="text-secondary">Aucun créneau.</td>
                                        </tr>
                                    <?php endif; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="col-12">
                    <div class="sh-card p-4">
                        <div class="fw-bold mb-3">Ajouter une absence (ponctuelle)</div>

                        <form method="POST" class="row g-2 align-items-end">
                            <input type="hidden" name="action" value="add_absence">

                            <div class="col-md-5">
                                <label class="form-label">Début</label>
                                <input type="datetime-local" name="start_datetime" class="form-control" required>
                            </div>

                            <div class="col-md-5">
                                <label class="form-label">Fin</label>
                                <input type="datetime-local" name="end_datetime" class="form-control" required>
                            </div>

                            <div class="col-md-2 d-grid">
                                <button class="btn btn-sh-gold" type="submit">Ajouter</button>
                            </div>
                        </form>

                        <hr>

                        <div class="fw-bold mb-2">Mes absences</div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Début</th>
                                        <th>Fin</th>
                                        <th style="width: 1%;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if (!empty($absences)): ?>
                                        <?php foreach ($absences as $a): ?>
                                            <tr>
                                                <td><?= !empty($a["start_datetime"]) ? date("d/m/Y H:i", strtotime($a["start_datetime"])) : "N/A" ?></td>
                                                <td><?= !empty($a["end_datetime"]) ? date("d/m/Y H:i", strtotime($a["end_datetime"])) : "N/A" ?></td>
                                                <td>
                                                    <form method="POST" onsubmit="return confirm('Supprimer cette absence ?');">
                                                        <input type="hidden" name="action" value="delete_absence">
                                                        <input type="hidden" name="id" value="<?= (int)($a["id"] ?? 0) ?>">
                                                        <button class="btn btn-outline-danger btn-sm" type="submit">Supprimer</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        <?php endforeach; ?>
                                    <?php else: ?>
                                        <tr>
                                            <td colspan="3" class="text-secondary">Aucune absence.</td>
                                        </tr>
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