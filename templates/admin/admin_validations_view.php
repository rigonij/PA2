<?php
$pageTitle = "Admin • Demandes de validation";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$filter = $filter ?? "";
$providers = $providers ?? [];
$error = $error ?? "";
$success = $success ?? "";

function renderValidationBadge($status)
{
    if ($status == 1) {
        echo '<span class="badge text-bg-success">Validé</span>';
    } elseif ($status == 2) {
        echo '<span class="badge text-bg-danger">Refusé</span>';
    } else {
        echo '<span class="badge text-bg-warning">En attente</span>';
    }
}
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Demandes de validation prestataires</h1>
            <p class="text-secondary mb-0">Validation des comptes prestataires sur dossier PDF</p>
        </div>
        <a class="btn btn-outline-secondary" href="admin_dashboard.php">← Retour</a>
    </div>

    <?php if (!empty($error)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>
    <?php if (!empty($success)): ?>
        <div class="alert alert-success"><?= htmlspecialchars($success) ?></div>
    <?php endif; ?>

    <div class="sh-card p-3 mb-3">
        <div class="d-flex gap-2 flex-wrap">
            <a href="?" class="btn btn-sm btn-outline-secondary <?= $filter === "" ? "active" : "" ?>">Tous</a>
            <a href="?status=0" class="btn btn-sm btn-outline-warning <?= $filter === "0" ? "active" : "" ?>">En attente</a>
            <a href="?status=1" class="btn btn-sm btn-outline-success <?= $filter === "1" ? "active" : "" ?>">Validés</a>
            <a href="?status=2" class="btn btn-sm btn-outline-danger <?= $filter === "2" ? "active" : "" ?>">Refusés</a>
        </div>
    </div>

    <div class="sh-card p-3">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>Nom</th>
                        <th>Prénom</th>
                        <th>Email</th>
                        <th>Société</th>
                        <th>Statut</th>
                        <th>Document</th>
                            <th>Description</th>
                        <th style="width:1%;" class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($providers)): ?>
                        <?php foreach ($providers as $p):
                            $pid = (int)($p["id"] ?? 0);
                            $status = (int)($p["validation_status"] ?? 0);
                        ?>
                            <tr>
                                <td><?= htmlspecialchars($p["nom"] ?? "") ?></td>
                                <td><?= htmlspecialchars($p["prenom"] ?? "") ?></td>
                                <td><?= htmlspecialchars($p["email"] ?? "") ?></td>
                                <td><?= htmlspecialchars($p["company_name"] ?? "") ?></td>
                                <td><?php renderValidationBadge($status); ?></td>
                                <td>
                                    <?php if (!empty($p["has_document"])): ?>
                                        <a href="admin_download_provider_pdf.php?id=<?= $pid ?>"
                                            class="btn btn-sm btn-outline-primary" target="_blank">
                                            Télécharger PDF
                                        </a>
                                    <?php else: ?>
                                        <span class="text-secondary small">Aucun</span>
                                    <?php endif; ?>
                                </td>
                                <td class="text-secondary small" style="max-width:260px;">
                                    <?php $descText = (string)($p["description"] ?? ""); $descShort = mb_strimwidth($descText, 0, 25, "..."); ?>
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="text-truncate flex-grow-1"><?= htmlspecialchars($descShort) ?></span>
                                        <?php if (mb_strlen($descText) > 25): ?>
                                            <button type="button" class="btn btn-sm btn-outline-secondary detail-btn flex-shrink-0" data-detail-title="Description du prestataire" data-detail-text="<?= htmlspecialchars($descText, ENT_QUOTES) ?>">Détails</button>
                                        <?php endif; ?>
                                    </div>
                                </td>
                                <td class="text-end" style="white-space:nowrap;">
                                    <?php if ($status !== 1): ?>
                                        <button type="button" class="btn btn-success btn-sm"
                                            data-bs-toggle="modal"
                                            data-bs-target="#validateModal"
                                            data-provider-id="<?= $pid ?>"
                                            data-provider-name="<?= htmlspecialchars($p["company_name"] ?? "") ?>">
                                            Valider
                                        </button>
                                    <?php endif; ?>
                                    <?php if ($status !== 2): ?>
                                        <form method="POST" class="d-inline"
                                            onsubmit="return confirm('Refuser ce prestataire ?');">
                                            <input type="hidden" name="action" value="reject_provider">
                                            <input type="hidden" name="provider_id" value="<?= $pid ?>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">Refuser</button>
                                        </form>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="8" class="text-secondary">Aucune demande.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="validateModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form method="POST" action="admin_validations.php">
                <input type="hidden" name="action" value="validate_with_services">
                <input type="hidden" name="provider_id" id="modalProviderId">
                <div class="modal-header">
                    <h5 class="modal-title">Valider <span id="modalProviderName"></span></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="text-secondary">Coche les prestations que ce prestataire est autorisé à proposer.</p>
                    <div id="modalCategoriesContainer">
                        <div class="text-center text-secondary">Chargement…</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-success">Valider</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.getElementById("validateModal").addEventListener("show.bs.modal", function(ev) {
        const btn = ev.relatedTarget;
        const providerId = btn.getAttribute("data-provider-id");
        const providerName = btn.getAttribute("data-provider-name");
        document.getElementById("modalProviderId").value = providerId;
        document.getElementById("modalProviderName").textContent = providerName;

        const container = document.getElementById("modalCategoriesContainer");
        container.innerHTML = '<div class="text-center text-secondary">Chargement…</div>';

        fetch('admin_provider_authorize.php?id=' + providerId)
            .then(r => r.json())
            .then(data => {
                if (!data.success) {
                    container.innerHTML = '<div class="alert alert-danger">' + (data.message || 'Erreur') + '</div>';
                    return;
                }
                const groups = data.categories || [];
                if (groups.length === 0) {
                    container.innerHTML = '<div class="alert alert-warning">Aucune catégorie disponible.</div>';
                    return;
                }
                let html = '';
                groups.forEach(group => {
                    html += '<h6 class="mt-3">' + group.category_name + '</h6>';
                    group.services.forEach(s => {
                        html += '<div class="form-check">';
                        html += '<input class="form-check-input" type="checkbox" name="authorized_service_type_ids[]" value="' + s.id + '" id="svc_' + s.id + '"' + (s.authorized ? ' checked' : '') + '>';
                        html += '<label class="form-check-label" for="svc_' + s.id + '">' + s.name + '</label>';
                        html += '</div>';
                    });
                });
                container.innerHTML = html;
            })
            .catch(e => {
                container.innerHTML = '<div class="alert alert-danger">Erreur : ' + e.message + '</div>';
            });
    });

    function toggleCat(btn) {
        const block = btn.closest(".mb-3");
        const cbs = block.querySelectorAll(".cat-cb");
        const allChecked = Array.from(cbs).every(cb => cb.checked);
        cbs.forEach(cb => cb.checked = !allChecked);
        btn.textContent = allChecked ? "Tout cocher" : "Tout décocher";
    }
</script>

<?php include __DIR__ . "/../common/footer-scripts.php"; ?>

<div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detailModalTitle">Détails</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
            </div>
            <div class="modal-body" id="detailModalBody" style="white-space:pre-wrap; word-break:break-word;"></div>
        </div>
    </div>
</div>
<script>
document.addEventListener("click", function(e) {
    const b = e.target.closest(".detail-btn");
    if (!b) return;
    document.getElementById("detailModalTitle").textContent = b.dataset.detailTitle || "Détails";
    document.getElementById("detailModalBody").textContent = b.dataset.detailText || "";
    bootstrap.Modal.getOrCreateInstance(document.getElementById("detailModal")).show();
});
</script>
