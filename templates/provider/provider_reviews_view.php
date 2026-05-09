<?php
$pageTitle = "Prestataire • Mes avis";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
?>
<div class="container py-4">
    <?php include __DIR__ . "/partials/topbar.php"; ?>
    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/partials/sidebar.php"; ?>
        </div>
        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Mes avis</h1>
                <p class="text-secondary mb-0">Avis laissés par les seniors sur vos prestations.</p>
            </div>
            <div class="sh-card p-3">
                <?php if ($loadError): ?>
                    <p class="text-danger mb-0"><?= htmlspecialchars($loadError) ?></p>
                <?php elseif (empty($reviews)): ?>
                    <p class="text-secondary mb-0">Aucun avis pour le moment.</p>
                <?php else: ?>
                    <?php foreach ($reviews as $rv):
                        $rating = (int)$rv["rating"];
                        $stars = str_repeat("★", $rating) . str_repeat("☆", 5 - $rating);
                        $updated = "";
                        if (!empty($rv["updated_at"])) {
                            try {
                                $dt = new DateTime($rv["updated_at"]);
                                $dt->setTimezone(new DateTimeZone("Europe/Paris"));
                                $updated = $dt->format("d/m/Y H:i");
                            } catch (Exception $e) {
                                $updated = $rv["updated_at"];
                            }
                        }
                    ?>
                        <div class="border-bottom py-3">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <span class="text-warning fs-5"><?= $stars ?></span>
                                    <span class="fw-bold"><?= htmlspecialchars($rv["author"]) ?></span>
                                    <span class="text-secondary small">— <?= htmlspecialchars($updated) ?></span>
                                </div>
                                <div>
                                    <?php if (!empty($rv["reported_by_me"])): ?>
                                        <span class="badge text-bg-warning">Déjà signalé</span>
                                    <?php else: ?>
                                        <button class="btn btn-outline-danger btn-sm report-btn" data-review-id="<?= (int)$rv["id"] ?>">Signaler</button>
                                    <?php endif; ?>
                                </div>
                            </div>
                            <?php if (!empty($rv["comment"])): ?>
                                <div class="mt-2"><?= nl2br(htmlspecialchars($rv["comment"])) ?></div>
                            <?php else: ?>
                                <div class="mt-2 text-secondary small">(Pas de commentaire)</div>
                            <?php endif; ?>
                        </div>
                    <?php endforeach; ?>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="reportModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Signaler cet avis</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="reportReviewId">
                <label class="form-label">Raison du signalement</label>
                <textarea id="reportReason" class="form-control" rows="4" placeholder="Expliquez pourquoi cet avis pose problème..."></textarea>
                <div id="reportStatus" class="small mt-2"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-sh-gold fw-bold" id="reportSubmitBtn">Envoyer le signalement</button>
            </div>
        </div>
    </div>
</div>

<script>
    (function() {
        document.querySelectorAll(".report-btn").forEach(function(b) {
            b.addEventListener("click", function() {
                document.getElementById("reportReviewId").value = b.dataset.reviewId;
                document.getElementById("reportReason").value = "";
                document.getElementById("reportStatus").textContent = "";
                new bootstrap.Modal(document.getElementById("reportModal")).show();
            });
        });

        document.getElementById("reportSubmitBtn").addEventListener("click", async function() {
            const reviewId = parseInt(document.getElementById("reportReviewId").value);
            const reason = document.getElementById("reportReason").value.trim();
            const statusEl = document.getElementById("reportStatus");
            if (!reason) {
                statusEl.textContent = "Indique une raison";
                statusEl.className = "small mt-2 text-danger";
                return;
            }
            statusEl.textContent = "Envoi...";
            statusEl.className = "small mt-2 text-secondary";
            try {
                const r = await fetch("provider_report_review.php", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({
                        review_id: reviewId,
                        reason: reason
                    })
                });
                const j = await r.json();
                if (j.success) {
                    statusEl.textContent = "Signalement envoyé";
                    statusEl.className = "small mt-2 text-success";
                    setTimeout(function() {
                        window.location.reload();
                    }, 800);
                } else {
                    statusEl.textContent = j.message || "Erreur";
                    statusEl.className = "small mt-2 text-danger";
                }
            } catch (e) {
                statusEl.textContent = "Erreur réseau";
                statusEl.className = "small mt-2 text-danger";
            }
        });
    })();
</script>

<?php
include __DIR__ . "/../common/footer.php";
include __DIR__ . "/../common/footer-scripts.php";
