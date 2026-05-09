<?php
$pageTitle = "Admin • Evenements";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$events = $events ?? [];
$error = $error ?? "";

$nowTs = time();
$upcoming = [];
$past = [];
foreach ($events as $e) {
    $ts = strtotime($e["event_date"] ?? "");
    if ($ts !== false && $ts >= $nowTs) {
        $upcoming[] = $e;
    } else {
        $past[] = $e;
    }
}
usort($upcoming, function ($a, $b) {
    return strtotime($a["event_date"]) - strtotime($b["event_date"]);
});
usort($past, function ($a, $b) {
    return strtotime($b["event_date"]) - strtotime($a["event_date"]);
});

function placesCell($e)
{
    $reg = (int)($e["registered_count"] ?? 0);
    $max = (int)($e["max_participants"] ?? 0);
    if ($max > 0) {
        return $reg . " / " . $max;
    }
    return $reg . " / &infin;";
}
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Gestion des evenements</h1>
            <p class="text-secondary mb-0">Creer, modifier et supprimer les evenements</p>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-primary btn-sm"
                onclick="document.getElementById('event-form').classList.toggle('d-none')">
                Ajouter un evenement
            </button>
            <a class="btn btn-outline-secondary" href="admin_dashboard.php">Retour</a>
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
                <div class="col-12">
                    <label class="form-label">Description (optionnel, recommande)</label>
                    <textarea class="form-control" name="description" rows="5"
                        placeholder="Programme, intervenants, public concerne, ce qu'il faut amener..."></textarea>
                    <div class="form-text">Ce texte sera affiche aux seniors via un bouton Details.</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Date</label>
                    <input type="datetime-local" class="form-control" name="event_date" id="createEventDate" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Participants max</label>
                    <input type="number" class="form-control" name="max_participants" min="1" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Prix (EUR)</label>
                    <input type="number" class="form-control" name="price" step="0.01" min="0" value="0" required>
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

    <div class="sh-card p-3 mb-3">
        <h2 class="h5 fw-bold mb-3">A venir</h2>
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Titre</th>
                        <th>Lieu</th>
                        <th>Date</th>
                        <th>Places</th>
                        <th>Prix</th>
                        <th style="width:1%;" class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($upcoming)): ?>
                        <?php foreach ($upcoming as $event): ?>
                            <tr>
                                <td><?= htmlspecialchars($event['id']) ?></td>
                                <td class="fw-bold"><?= htmlspecialchars($event['title']) ?></td>
                                <td><?= htmlspecialchars($event['location']) ?></td>
                                <td><?= htmlspecialchars(fmt_dt($event['event_date'])) ?></td>
                                <td><?= placesCell($event) ?></td>
                                <td><?= number_format((float)($event['price'] ?? 0), 2, ',', ' ') ?> EUR</td>
                                <td class="text-end" style="white-space:nowrap;">
                                    <button type="button" class="btn btn-sm btn-outline-secondary"
                                        onclick="openEventRegistrations(<?= (int)$event['id'] ?>)">
                                        Details
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                        onclick='openEditEventModal(<?= htmlspecialchars(json_encode($event, JSON_HEX_APOS | JSON_HEX_QUOT | JSON_UNESCAPED_UNICODE), ENT_QUOTES) ?>)'>
                                        Modifier
                                    </button>
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
                            <td colspan="7" class="text-secondary">Aucun evenement a venir.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>

    <div class="sh-card p-3">
        <div class="d-flex justify-content-between align-items-center" style="cursor:pointer;"
            onclick="toggleHistorique()">
            <div>
                <h2 class="h5 fw-bold mb-0">Historique</h2>
                <p class="text-secondary small mb-0"><?= count($past) ?> evenement(s) passe(s)</p>
            </div>
            <div class="d-flex gap-2 align-items-center">
                <?php if (!empty($past)): ?>
                    <form method="POST" action="admin_event.php" style="display:inline"
                        onclick="event.stopPropagation();"
                        onsubmit="return confirm('Vider tout l\'historique ? Cette action est irreversible.');">
                        <input type="hidden" name="action" value="clear_history">
                        <button type="submit" class="btn btn-sm btn-outline-danger">Vider l'historique</button>
                    </form>
                <?php endif; ?>
                <span id="historiqueChevron" style="font-size:1.25rem;">&#9656;</span>
            </div>
        </div>
        <div id="historiqueBody" class="mt-3" style="display:none;">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Titre</th>
                            <th>Lieu</th>
                            <th>Date</th>
                            <th>Places</th>
                            <th>Prix</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (!empty($past)): ?>
                            <?php foreach ($past as $event): ?>
                                <tr>
                                    <td><?= htmlspecialchars($event['id']) ?></td>
                                    <td class="fw-bold"><?= htmlspecialchars($event['title']) ?></td>
                                    <td><?= htmlspecialchars($event['location']) ?></td>
                                    <td><?= htmlspecialchars(fmt_dt($event['event_date'])) ?></td>
                                    <td><?= placesCell($event) ?></td>
                                    <td><?= number_format((float)($event['price'] ?? 0), 2, ',', ' ') ?> EUR</td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="6" class="text-secondary">Aucun evenement passe.</td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editEventModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <form method="POST" action="admin_event.php">
                    <div class="modal-header">
                        <h5 class="modal-title">Modifier l'evenement</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="update_id" id="editEventId">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Titre</label>
                                <input type="text" class="form-control" name="title" id="editEventTitle" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Lieu</label>
                                <input type="text" class="form-control" name="location" id="editEventLocation" required>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Description (optionnel, recommande)</label>
                                <textarea class="form-control" name="description" id="editEventDescription" rows="5"
                                    placeholder="Programme, intervenants, public concerne, ce qu'il faut amener..."></textarea>
                                <div class="form-text">Ce texte sera affiche aux seniors via un bouton Details.</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Date</label>
                                <input type="datetime-local" class="form-control" name="event_date" id="editEventDate" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Participants max</label>
                                <input type="number" class="form-control" name="max_participants" id="editEventMax" min="1" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Prix (EUR)</label>
                                <input type="number" class="form-control" name="price" id="editEventPrice" step="0.01" min="0" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Enregistrer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="eventRegistrationsModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Inscrits — <span id="erEventTitle"></span></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="text-secondary mb-3">
                        Places : <span id="erPlacesCount" class="fw-bold"></span>
                    </p>
                    <div id="erStatus" class="text-secondary small mb-2"></div>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Nom</th>
                                    <th>Prenom</th>
                                    <th>Email</th>
                                    <th>Telephone</th>
                                </tr>
                            </thead>
                            <tbody id="erTbody">
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        (function() {
            const now = new Date();
            const pad = n => String(n).padStart(2, '0');
            const minLocal = `${now.getFullYear()}-${pad(now.getMonth()+1)}-${pad(now.getDate())}T${pad(now.getHours())}:${pad(now.getMinutes())}`;
            const c = document.getElementById('createEventDate');
            if (c) c.min = minLocal;
        })();

        function toggleHistorique() {
            const body = document.getElementById("historiqueBody");
            const chevron = document.getElementById("historiqueChevron");
            if (body.style.display === "none") {
                body.style.display = "block";
                chevron.innerHTML = "&#9662;";
            } else {
                body.style.display = "none";
                chevron.innerHTML = "&#9656;";
            }
        }

        function openEditEventModal(ev) {
            document.getElementById('editEventId').value = ev.id;
            document.getElementById('editEventTitle').value = ev.title || '';
            document.getElementById('editEventLocation').value = ev.location || '';
            document.getElementById('editEventDescription').value = ev.description || '';
            document.getElementById('editEventMax').value = ev.max_participants || 1;
            document.getElementById('editEventPrice').value = (ev.price !== undefined ? ev.price : 0);
            const raw = ev.event_date || '';
            const d = new Date(raw);
            if (!isNaN(d.getTime())) {
                const pad = n => String(n).padStart(2, '0');
                const localStr = `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
                document.getElementById('editEventDate').value = localStr;
            } else {
                document.getElementById('editEventDate').value = '';
            }
            new bootstrap.Modal(document.getElementById('editEventModal')).show();
        }

        function escapeHtml(s) {
            return String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#39;'
            } [c]));
        }

        async function openEventRegistrations(id) {
            const tbody = document.getElementById('erTbody');
            const status = document.getElementById('erStatus');
            const title = document.getElementById('erEventTitle');
            const places = document.getElementById('erPlacesCount');
            tbody.innerHTML = '';
            title.textContent = '';
            places.textContent = '';
            status.textContent = 'Chargement...';
            new bootstrap.Modal(document.getElementById('eventRegistrationsModal')).show();
            try {
                const r = await fetch('api_admin_event_registrations.php?id=' + encodeURIComponent(id));
                const j = await r.json();
                if (!j.success) {
                    status.textContent = j.message || 'Erreur';
                    return;
                }
                status.textContent = '';
                title.textContent = j.title || ('Evenement ' + id);
                const max = parseInt(j.max_participants || 0, 10);
                const reg = parseInt(j.registered_count || 0, 10);
                places.innerHTML = max > 0 ? (reg + ' / ' + max) : (reg + ' / &infin;');
                const list = Array.isArray(j.registrations) ? j.registrations : [];
                if (list.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="4" class="text-secondary">Aucun inscrit.</td></tr>';
                    return;
                }
                tbody.innerHTML = list.map(u => (
                    '<tr>' +
                    '<td class="fw-bold">' + escapeHtml(u.nom) + '</td>' +
                    '<td>' + escapeHtml(u.prenom) + '</td>' +
                    '<td>' + escapeHtml(u.email) + '</td>' +
                    '<td>' + escapeHtml(u.phone) + '</td>' +
                    '</tr>'
                )).join('');
            } catch (e) {
                status.textContent = 'Erreur reseau';
            }
        }
    </script>

    <?php include __DIR__ . "/../common/footer-scripts.php"; ?>
</div>