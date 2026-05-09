<?php
function renderCataloguePrestataires(array $providers): void
{
    $pageTitle = "SilverHappy • Catalogue Prestataires";
    $isSeniorUi = true;
    include __DIR__ . "/../common/head.php";
    include __DIR__ . "/../common/header.php";
?>
    <div class="container py-4">
        <?php include __DIR__ . "/../common/topbar.php"; ?>
        <div class="row g-3">
            <div class="col-lg-3">
                <?php include __DIR__ . "/../common/sidebar.php"; ?>
            </div>
            <div class="col-lg-9">
                <div class="sh-card p-4 mb-3">
                    <h1 class="h4 mb-1">Catalogue • Prestataires</h1>
                    <p class="text-secondary mb-0">Prestataires vérifiés disponibles.</p>
                </div>
                <?php if (empty($providers)): ?>
                    <div class="sh-card p-4">
                        <p class="text-secondary mb-0">Aucun prestataire disponible pour le moment.</p>
                    </div>
                <?php else: ?>
                    <div class="row g-3">
                        <?php foreach ($providers as $p):
                            $pid         = (int)($p["id"] ?? 0);
                            $companyName = htmlspecialchars($p["company_name"] ?? "Entreprise");
                            $nom         = htmlspecialchars($p["nom"] ?? "");
                            $prenom      = htmlspecialchars($p["prenom"] ?? "");
                            $email       = htmlspecialchars($p["email"] ?? "");
                            $phone       = htmlspecialchars($p["phone"] ?? "");
                            $description = htmlspecialchars($p["description"] ?? "");
                            $avg         = (float)($p["avg_rating"] ?? 0);
                            $count       = (int)($p["review_count"] ?? 0);
                            $modalId     = "modalProfil" . $pid;
                        ?>
                            <div class="col-md-6">
                                <div class="sh-card p-4 h-100 d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <div class="fw-bold"><?= $companyName ?></div>
                                                <div class="text-secondary small"><?= $prenom ?> <?= $nom ?></div>
                                            </div>
                                            <span class="badge text-bg-success">Vérifié</span>
                                        </div>
                                        <?php if ($description): ?>
                                            <p class="text-secondary small mb-0"><?= $description ?></p>
                                        <?php endif; ?>
                                    </div>
                                    <div class="d-flex gap-2 mt-3 align-items-center">
                                        <button class="btn btn-outline-secondary btn-sm"
                                            data-bs-toggle="modal"
                                            data-bs-target="#<?= $modalId ?>">
                                            Profil
                                        </button>
                                        <a class="btn btn-sh-gold btn-sm fw-bold"
                                            href="messagerie.php?open_user=<?= $pid ?>">
                                            Contacter
                                        </a>
                                        <button class="btn btn-outline-danger btn-sm"
                                            onclick="openReportUserModal(<?= $pid ?>, '<?= htmlspecialchars(addslashes($prenom . ' ' . $nom)) ?>')">
                                            <i class="bi bi-flag"></i>
                                        </button>
                                        <span class="ms-auto small">
                                            <?php if ($count > 0): ?>
                                                <span class="text-warning">★</span>
                                                <span class="fw-bold"><?= number_format($avg, 1, ",", " ") ?></span>
                                                <span class="text-secondary">(<?= $count ?>)</span>
                                            <?php else: ?>
                                                <span class="text-secondary">Aucun avis</span>
                                            <?php endif; ?>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="modal fade" id="<?= $modalId ?>" tabindex="-1" data-provider-id="<?= $pid ?>">
                                <div class="modal-dialog modal-dialog-centered modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title"><?= $companyName ?></h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <dl class="row mb-3">
                                                <dt class="col-sm-4">Entreprise</dt>
                                                <dd class="col-sm-8"><?= $companyName ?></dd>
                                                <dt class="col-sm-4">Nom</dt>
                                                <dd class="col-sm-8"><?= $prenom ?> <?= $nom ?></dd>
                                                <?php if ($email): ?>
                                                    <dt class="col-sm-4">Email</dt>
                                                    <dd class="col-sm-8"><?= $email ?></dd>
                                                <?php endif; ?>
                                                <?php if ($phone): ?>
                                                    <dt class="col-sm-4">Téléphone</dt>
                                                    <dd class="col-sm-8"><?= $phone ?></dd>
                                                <?php endif; ?>
                                                <?php if ($description): ?>
                                                    <dt class="col-sm-4">Description</dt>
                                                    <dd class="col-sm-8"><?= $description ?></dd>
                                                <?php endif; ?>
                                            </dl>
                                            <hr>
                                            <h6 class="mb-2">Mon avis</h6>
                                            <div class="mb-2 review-stars-input" data-provider-id="<?= $pid ?>" style="font-size: 1.5rem; cursor: pointer; color: #ddd;">
                                                <span data-value="1">★</span>
                                                <span data-value="2">★</span>
                                                <span data-value="3">★</span>
                                                <span data-value="4">★</span>
                                                <span data-value="5">★</span>
                                            </div>
                                            <textarea class="form-control mb-2 review-comment" rows="2" placeholder="Commentaire (optionnel)"></textarea>
                                            <div class="d-flex gap-2 mb-3">
                                                <button class="btn btn-sh-gold btn-sm fw-bold review-save-btn">Enregistrer</button>
                                                <button class="btn btn-outline-danger btn-sm review-delete-btn" style="display:none;">Supprimer mon avis</button>
                                                <span class="ms-2 small text-secondary review-status"></span>
                                            </div>
                                            <hr>
                                            <h6 class="mb-2">Tous les avis (<span class="review-list-count">0</span>)</h6>
                                            <div class="review-list small">
                                                <p class="text-secondary mb-0">Chargement...</p>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <a class="btn btn-sh-gold fw-bold"
                                                href="messagerie.php?open_user=<?= $pid ?>">
                                                Contacter
                                            </a>
                                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
    <script>
        (function() {
            function paintStars(container, value) {
                container.querySelectorAll("span").forEach(function(s) {
                    s.style.color = (parseInt(s.dataset.value) <= value) ? "#f5b301" : "#ddd";
                });
            }

            function fmtDate(iso) {
                if (!iso) return "";
                try {
                    const d = new Date(iso);
                    return d.toLocaleDateString("fr-FR") + " " + d.toLocaleTimeString("fr-FR", {
                        hour: "2-digit",
                        minute: "2-digit"
                    });
                } catch (e) {
                    return iso;
                }
            }
            document.querySelectorAll(".modal[data-provider-id]").forEach(function(modal) {
                const providerId = modal.dataset.providerId;
                const starsEl = modal.querySelector(".review-stars-input");
                const commentEl = modal.querySelector(".review-comment");
                const saveBtn = modal.querySelector(".review-save-btn");
                const delBtn = modal.querySelector(".review-delete-btn");
                const statusEl = modal.querySelector(".review-status");
                const listEl = modal.querySelector(".review-list");
                const countEl = modal.querySelector(".review-list-count");
                let currentRating = 0;

                starsEl.querySelectorAll("span").forEach(function(s) {
                    s.addEventListener("mouseenter", function() {
                        paintStars(starsEl, parseInt(s.dataset.value));
                    });
                    s.addEventListener("click", function() {
                        currentRating = parseInt(s.dataset.value);
                        paintStars(starsEl, currentRating);
                    });
                });
                starsEl.addEventListener("mouseleave", function() {
                    paintStars(starsEl, currentRating);
                });

                async function loadAll() {
                    statusEl.textContent = "";
                    try {
                        const r1 = await fetch("senior_reviews.php?provider_id=" + providerId);
                        const j1 = await r1.json();
                        if (j1.success && j1.review) {
                            currentRating = j1.review.rating;
                            commentEl.value = j1.review.comment || "";
                            delBtn.style.display = "inline-block";
                        } else {
                            currentRating = 0;
                            commentEl.value = "";
                            delBtn.style.display = "none";
                        }
                        paintStars(starsEl, currentRating);
                    } catch (e) {}
                    try {
                        const r2 = await fetch("provider_public_reviews.php?provider_id=" + providerId);
                        const j2 = await r2.json();
                        if (j2.success) {
                            countEl.textContent = j2.count || 0;
                            if (!j2.reviews || j2.reviews.length === 0) {
                                listEl.innerHTML = '<p class="text-secondary mb-0">Aucun avis pour le moment.</p>';
                            } else {
                                listEl.innerHTML = j2.reviews.map(function(rv) {
                                    const stars = "★".repeat(rv.rating) + "☆".repeat(5 - rv.rating);
                                    const author = rv.author || "Anonyme";
                                    const comment = rv.comment ? '<div class="mt-1">' + escapeHtml(rv.comment) + '</div>' : "";
                                    return '<div class="border-bottom py-2"><span class="text-warning">' + stars + '</span> <span class="fw-bold">' + escapeHtml(author) + '</span> <span class="text-secondary">— ' + fmtDate(rv.updated_at) + '</span>' + comment + '</div>';
                                }).join("");
                            }
                        }
                    } catch (e) {
                        listEl.innerHTML = '<p class="text-danger mb-0">Erreur chargement avis.</p>';
                    }
                }

                function escapeHtml(s) {
                    return String(s).replace(/[&<>"']/g, function(c) {
                        return {
                            "&": "&amp;",
                            "<": "&lt;",
                            ">": "&gt;",
                            '"': "&quot;",
                            "'": "&#39;"
                        } [c];
                    });
                }

                modal.addEventListener("show.bs.modal", loadAll);

                saveBtn.addEventListener("click", async function() {
                    if (currentRating < 1) {
                        statusEl.textContent = "Choisis une note d'abord";
                        statusEl.className = "ms-2 small text-danger";
                        return;
                    }
                    statusEl.textContent = "Enregistrement...";
                    statusEl.className = "ms-2 small text-secondary";
                    try {
                        const r = await fetch("senior_reviews.php", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json"
                            },
                            body: JSON.stringify({
                                provider_id: parseInt(providerId),
                                rating: currentRating,
                                comment: commentEl.value
                            })
                        });
                        const j = await r.json();
                        if (j.success) {
                            statusEl.textContent = "Avis enregistré";
                            statusEl.className = "ms-2 small text-success";
                            delBtn.style.display = "inline-block";
                            loadAll();
                        } else {
                            statusEl.textContent = j.message || "Erreur";
                            statusEl.className = "ms-2 small text-danger";
                        }
                    } catch (e) {
                        statusEl.textContent = "Erreur réseau";
                        statusEl.className = "ms-2 small text-danger";
                    }
                });

                delBtn.addEventListener("click", async function() {
                    if (!confirm("Supprimer ton avis ?")) return;
                    try {
                        const r = await fetch("senior_reviews.php?provider_id=" + providerId, {
                            method: "DELETE"
                        });
                        const j = await r.json();
                        if (j.success) {
                            currentRating = 0;
                            commentEl.value = "";
                            paintStars(starsEl, 0);
                            delBtn.style.display = "none";
                            statusEl.textContent = "Avis supprimé";
                            statusEl.className = "ms-2 small text-success";
                            loadAll();
                        } else {
                            statusEl.textContent = j.message || "Erreur";
                            statusEl.className = "ms-2 small text-danger";
                        }
                    } catch (e) {
                        statusEl.textContent = "Erreur réseau";
                        statusEl.className = "ms-2 small text-danger";
                    }
                });
            });
        })();
    </script>
<?php
    include __DIR__ . "/../common/report_user_modal.php";
    include __DIR__ . "/../common/footer.php";
    include __DIR__ . "/../common/footer-scripts.php";
}
