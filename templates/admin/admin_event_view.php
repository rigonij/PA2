<?php
$pageTitle = "Admin • Evenements";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
?>

<div class="container py-4">

    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Gestion des evenements</h1>
            <p class="text-secondary mb-0">Valider, refuser ou supprimer les evenements</p>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-primary btn-sm" onclick="document.getElementById('event-form').classList.toggle('d-none')">
                Ajouter un evenement
            </button>
            <a class="btn btn-outline-secondary" href="admin_dashboard.php">← Retour</a>
        </div>
    </div>

    <?php if (!empty($error)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <div class="sh-card p-4 mb-3 d-none" id="event-form">
        <h2 class="h5 fw-bold mb-3">Nouvel evenement</h2>
        <form method="POST" action="admin_event_add.php">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Titre</label>
                    <input type="text" class="form-control" name="title" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Lieu</label>
                    <input type="text" class="form-control" name="location" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Date</label>
                    <input type="datetime-local" class="form-control" name="event_date"
                        min="<?= date('Y-m-d\TH:i') ?>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Participants max</label>
                    <input type="number" class="form-control" name="max_participants" required>
                </div>
                <div class="col-12 d-flex gap-2">
                    <button type="submit" class="btn btn-outline-primary">Ajouter</button>
                    <button type="button" class="btn btn-outline-secondary"
                        onclick="document.getElementById('event-form').classList.add('d-none')">
                        Fermer
                    </button>
                </div>
            </div>
        </form>
    </div>

    <div class="sh-card p-3">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Titre</th>
                        <th>Lieu</th>
                        <th>Date</th>
                        <th>Max participants</th>
                        <th>Statut</th>
                        <th style="width:1%;" class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($events)): ?>
                        <?php foreach ($events as $event): ?>
                            <tr>
                                <td><?= htmlspecialchars($event['id']) ?></td>
                                <td class="fw-bold"><?= htmlspecialchars($event['title']) ?></td>
                                <td><?= htmlspecialchars($event['location']) ?></td>
                                <td><?= htmlspecialchars($event['event_date']) ?></td>
                                <td><?= htmlspecialchars($event['max_participants']) ?></td>
                                <td>
                                    <?php if ($event['validation_status'] == 1): ?>
                                        <span class="badge text-bg-success">Valide</span>
                                    <?php elseif ($event['validation_status'] == 2): ?>
                                        <span class="badge text-bg-danger">Refuse</span>
                                    <?php else: ?>
                                        <span class="badge text-bg-warning">En attente</span>
                                    <?php endif; ?>
                                </td>
                                <td class="text-end" style="white-space:nowrap;">
                                    <form method="POST" action="admin_event.php" style="display:inline">
                                        <input type="hidden" name="event_id" value="<?= (int)$event['id'] ?>">
                                        <button type="submit" name="action" value="validate"
                                            class="btn btn-sm btn-outline-success">Valider</button>
                                        <button type="submit" name="action" value="refuse"
                                            class="btn btn-sm btn-outline-warning">Refuser</button>
                                    </form>
                                    <form method="POST" action="admin_event.php" style="display:inline"
                                        onsubmit="return confirm('Supprimer cet evenement ?')">
                                        <input type="hidden" name="delete_id" value="<?= (int)$event['id'] ?>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Supprimer</button>
                                    </form>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="7" class="text-secondary">Aucun evenement trouve.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>

</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>