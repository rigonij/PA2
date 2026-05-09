<?php
$pageTitle = "SilverHappy • Conseils";
$isSeniorUi = true;
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
$advices = $advices ?? [];
?>
<div class="container py-4">
    <?php include __DIR__ . "/../common/topbar.php"; ?>
    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/../common/sidebar.php"; ?>
        </div>
        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Conseils</h1>
                <p class="text-secondary mb-0">Conseils pratiques pour bien vivre au quotidien.</p>
            </div>
            <div class="row g-3">
                <?php foreach ($advices as $a): ?>
                    <?php
                    $id      = (int)($a["id"] ?? 0);
                    $title   = $a["title"] ?? "";
                    $excerpt = $a["excerpt"] ?? "";
                    ?>
                    <div class="col-md-4">
                        <div class="sh-card p-3">
                            <div class="fw-bold"><?= htmlspecialchars($title) ?></div>
                            <div class="text-secondary"><?= htmlspecialchars($excerpt) ?></div>
                            <div class="mt-3 d-flex gap-2 align-items-center">
                                <button type="button" class="btn btn-sh-gold" onclick="openAdviceModal(<?= $id ?>)">Lire</button>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
                <?php if (empty($advices)): ?>
                    <div class="col-12">
                        <div class="text-secondary">Aucun conseil disponible.</div>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="adviceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content sh-card">
            <div class="modal-body p-4">
                <div class="d-flex justify-content-between align-items-start gap-3 mb-3">
                    <div>
                        <h2 class="h5 mb-1" id="adviceModalTitle">Conseil</h2>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                    </div>
                </div>
                <div id="adviceModalLoader" class="text-secondary">Chargement…</div>
                <div id="adviceModalContent" style="display:none; white-space:pre-wrap;"></div>
                <div id="adviceModalError" class="text-danger" style="display:none;"></div>
            </div>
        </div>
    </div>
</div>
<script>
    async function openAdviceModal(id) {
        const titleEl = document.getElementById("adviceModalTitle");
        const loaderEl = document.getElementById("adviceModalLoader");
        const contentEl = document.getElementById("adviceModalContent");
        const errorEl = document.getElementById("adviceModalError");
        titleEl.textContent = "Conseil";
        contentEl.style.display = "none";
        errorEl.style.display = "none";
        loaderEl.style.display = "block";
        contentEl.textContent = "";
        errorEl.textContent = "";
        const modal = new bootstrap.Modal(document.getElementById("adviceModal"));
        modal.show();
        try {
            const r = await fetch("api_advice_detail.php?id=" + id);
            const j = await r.json();
            loaderEl.style.display = "none";
            if (j.success && j.advice) {
                titleEl.textContent = j.advice.title || "Conseil";
                contentEl.textContent = j.advice.content || "";
                contentEl.style.display = "block";
            } else {
                errorEl.textContent = j.message || "Impossible de charger ce conseil.";
                errorEl.style.display = "block";
            }
        } catch (e) {
            loaderEl.style.display = "none";
            errorEl.textContent = "Erreur réseau";
            errorEl.style.display = "block";
        }
    }
</script>
<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>