<?php
$pageTitle = "SilverHappy • Événements";
$isSeniorUi = true;
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
$events      = $events      ?? [];
$statusEvent = $statusEvent ?? "";
$errorMsg    = $errorMsg    ?? "";
?>
<div class="container py-4">
    <?php include __DIR__ . "/../common/topbar.php"; ?>
    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/../common/sidebar.php"; ?>
        </div>
        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Catalogue • Événements</h1>
            </div>

            <?php if (!empty($errorMsg)): ?>
                <div class="alert alert-danger"><?= htmlspecialchars($errorMsg) ?></div>
            <?php endif; ?>

            <?php if ($statusEvent === "success"): ?>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    Inscription confirmée ! Votre paiement a bien été reçu.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($statusEvent === "cancel"): ?>
                <div class="alert alert-warning alert-dismissible fade show" role="alert">
                    Paiement annulé. Vous n'avez pas été inscrit à l'événement.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($statusEvent === "error"): ?>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    Une erreur est survenue lors du paiement. Veuillez réessayer.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php endif; ?>

            <div class="row g-3">
                <?php foreach ($events as $e): ?>
                    <?php
                    $id     = (int)($e["id"] ?? 0);
                    $isPaid = !empty($e["is_paid"]);
                    $isReg  = !empty($e["is_registered"]);
                    $isFull = !empty($e["is_full"]);
                    $price  = (float)($e["price"] ?? 0);
                    $max    = (int)($e["max_participants"] ?? 0);
                    $avail  = (int)($e["available_spots"] ?? 0);
                    $priceLabel = $isPaid
                        ? number_format($price, 2, ',', ' ') . ' €'
                        : 'Gratuit';
                    ?>
                    <div class="col-md-6">
                        <div class="sh-card p-3">
                            <div class="fw-bold"><?= htmlspecialchars($e["title"] ?? "") ?></div>
                            <div class="text-secondary">
                                <?= htmlspecialchars(fmt_dt($e["event_date"] ?? "")) ?>
                                • <?= htmlspecialchars($e["location"] ?? "") ?>
                            </div>

                            <div class="mt-2 d-flex gap-2 flex-wrap">
                                <?php if ($max > 0 && isset($e["available_spots"])): ?>
                                    <span class="badge badge-sh"><?= $avail ?> / <?= $max ?> places restantes</span>
                                <?php elseif ($max > 0): ?>
                                    <span class="badge badge-sh">Max: <?= $max ?></span>
                                <?php endif; ?>

                                <?php if ($isPaid): ?>
                                    <span class="badge text-bg-warning"><?= $priceLabel ?></span>
                                <?php else: ?>
                                    <span class="badge text-bg-success">Gratuit</span>
                                <?php endif; ?>

                                <?php if ($isReg): ?>
                                    <span class="badge text-bg-success">Inscrit</span>
                                <?php elseif ($isFull): ?>
                                    <span class="badge text-bg-secondary">Complet</span>
                                <?php else: ?>
                                    <span class="badge text-bg-secondary">Non inscrit</span>
                                <?php endif; ?>
                            </div>

                            <div class="mt-3 d-flex gap-2 flex-wrap">
                                <button class="btn btn-outline-secondary" type="button"
                                    onclick="openEventDetailModal(<?= $id ?>)">Détails</button>

                                <?php if ($isReg): ?>
                                    <a class="btn btn-outline-danger"
                                        href="catalogue-evenements.php?action=unsubscribe&id=<?= $id ?>">
                                        Se désinscrire
                                    </a>
                                <?php elseif ($isFull): ?>
                                    <button class="btn btn-sh-gold" type="button" disabled>Complet</button>
                                <?php elseif ($isPaid): ?>
                                    <a class="btn btn-sh-gold"
                                        href="catalogue-evenements.php?action=pay_event&id=<?= $id ?>">
                                        Payer (<?= $priceLabel ?>)
                                    </a>
                                <?php else: ?>
                                    <a class="btn btn-sh-gold"
                                        href="catalogue-evenements.php?action=subscribe&id=<?= $id ?>">
                                        S'inscrire
                                    </a>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>

                <?php if (empty($events)): ?>
                    <div class="col-12">
                        <div class="text-secondary">Aucun événement disponible.</div>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="eventDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eventDetailTitle">Détails</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="eventDetailLoading" class="text-secondary">Chargement...</div>
                <div id="eventDetailError" class="alert alert-danger d-none"></div>
                <div id="eventDetailBody" class="d-none">
                    <p class="mb-1"><strong>Lieu :</strong> <span id="eventDetailLocation"></span></p>
                    <p class="mb-1"><strong>Date :</strong> <span id="eventDetailDate"></span></p>
                    <p class="mb-1"><strong>Tarif :</strong> <span id="eventDetailPrice"></span></p>
                    <p class="mb-3"><strong>Places :</strong> <span id="eventDetailSpots"></span></p>
                    <h6 class="fw-bold">Description</h6>
                    <p id="eventDetailDescription" class="text-secondary"></p>
                    <h6 class="fw-bold mt-3">Participants</h6>
                    <div id="eventDetailParticipants"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<script>
    function escapeHtml(s) {
        return String(s).replace(/[&<>"']/g, c => ({
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#39;'
        } [c]));
    }

    async function openEventDetailModal(id) {
        const loading = document.getElementById("eventDetailLoading");
        const errorEl = document.getElementById("eventDetailError");
        const body = document.getElementById("eventDetailBody");
        loading.classList.remove("d-none");
        errorEl.classList.add("d-none");
        body.classList.add("d-none");

        new bootstrap.Modal(document.getElementById("eventDetailModal")).show();

        try {
            const r = await fetch("api_event_detail.php?id=" + id);
            const j = await r.json();
            if (!j.success || !j.event) {
                loading.classList.add("d-none");
                errorEl.textContent = j.message || "Événement introuvable";
                errorEl.classList.remove("d-none");
                return;
            }
            const ev = j.event;
            document.getElementById("eventDetailTitle").textContent = ev.title || "Détails";
            document.getElementById("eventDetailLocation").textContent = ev.location || "—";

            const d = ev.event_date ? new Date(ev.event_date) : null;
            document.getElementById("eventDetailDate").textContent =
                d && !isNaN(d.getTime()) ?
                d.toLocaleString('fr-FR', {
                    dateStyle: 'long',
                    timeStyle: 'short'
                }) :
                (ev.event_date || "—");

            const price = parseFloat(ev.price || 0);
            document.getElementById("eventDetailPrice").textContent =
                price > 0 ? price.toFixed(2).replace('.', ',') + ' €' : 'Gratuit';

            const max = parseInt(ev.max_participants || 0);
            const avail = parseInt(ev.available_spots ?? max);
            document.getElementById("eventDetailSpots").textContent =
                max > 0 ? (avail + " / " + max + " places restantes") : "—";

            document.getElementById("eventDetailDescription").textContent =
                ev.description && ev.description.trim() ? ev.description : "Aucune description.";

            const list = ev.participants || [];
            const partEl = document.getElementById("eventDetailParticipants");
            partEl.innerHTML = list.length ?
                '<ul class="mb-0">' + list.map(p => '<li>' + escapeHtml(p.full_name || '—') + '</li>').join('') + '</ul>' :
                '<em class="text-secondary">Aucun participant inscrit.</em>';

            loading.classList.add("d-none");
            body.classList.remove("d-none");
        } catch (e) {
            loading.classList.add("d-none");
            errorEl.textContent = "Erreur réseau";
            errorEl.classList.remove("d-none");
        }
    }
</script>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>