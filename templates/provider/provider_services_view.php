<?php
$pageTitle = "SilverHappy • Prestataire • Mes services";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$items = $items ?? [];
$categories = $categories ?? [];
$error = $error ?? "";
$success = $success ?? "";
?>
<div class="container py-4">
    <?php include __DIR__ . "/partials/topbar.php"; ?>
    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/partials/sidebar.php"; ?>
        </div>
        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
                <div>
                    <h1 class="h4 mb-1">Mes services</h1>
                    <p class="text-secondary mb-0">Gérer votre catalogue de service.</p>
                </div>
                <button class="btn btn-sh-gold" type="button" data-bs-toggle="modal" data-bs-target="#addServiceModal" style="white-space: nowrap;">
                    Ajouter
                </button>
            </div>

            <?php if (!empty($error)): ?>
                <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
            <?php endif; ?>
            <?php if (!empty($success)): ?>
                <div class="alert alert-success"><?= htmlspecialchars($success) ?></div>
            <?php endif; ?>

            <div class="sh-card p-3">
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Service</th>
                                <th>Titre affiché</th>
                                <th>Prix</th>
                                <th>Exp (ans)</th>
                                <th>Actif</th>
                                <th style="width: 1%;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($items)): ?>
                                <?php foreach ($items as $it): ?>
                                    <?php
                                    $id = (int)($it["service_type_id"] ?? 0);
                                    $name = $it["name"] ?? "";
                                    $custom = $it["custom_title"] ?? "";
                                    $price = (float)($it["negotiated_price"] ?? 0);
                                    $exp = (int)($it["experience_years"] ?? 0);
                                    $active = !empty($it["is_active"]);
                                    ?>
                                    <tr>
                                        <td class="fw-bold"><?= htmlspecialchars($name) ?></td>
                                        <td><?= htmlspecialchars($custom !== "" ? $custom : "—") ?></td>
                                        <td><?= number_format($price, 2, ",", " ") ?> €</td>
                                        <td><?= (int)$exp ?></td>
                                        <td>
                                            <?php if ($active): ?>
                                                <span class="badge text-bg-success">Actif</span>
                                            <?php else: ?>
                                                <span class="badge text-bg-secondary">Inactif</span>
                                            <?php endif; ?>
                                        </td>
                                        <td style="white-space:nowrap;">
                                            <button
                                                type="button"
                                                class="btn btn-outline-secondary btn-sm"
                                                data-bs-toggle="modal"
                                                data-bs-target="#editServiceModal"
                                                data-id="<?= $id ?>"
                                                data-name="<?= htmlspecialchars($name, ENT_QUOTES) ?>"
                                                data-custom="<?= htmlspecialchars($custom, ENT_QUOTES) ?>"
                                                data-price="<?= htmlspecialchars((string)$price, ENT_QUOTES) ?>"
                                                data-exp="<?= (int)$exp ?>"
                                                data-active="<?= $active ? "1" : "0" ?>">
                                                Modifier
                                            </button>
                                            <a class="btn btn-outline-primary btn-sm"
                                                href="provider_service_horaires.php?service_type_id=<?= $id ?>&name=<?= urlencode($name) ?>">
                                                Horaires
                                            </a>
                                            <form method="POST" class="d-inline" onsubmit="return confirm('Supprimer ce service ?');">
                                                <input type="hidden" name="action" value="delete_service">
                                                <input type="hidden" name="service_type_id" value="<?= $id ?>">
                                                <button class="btn btn-outline-danger btn-sm" type="submit">Supprimer</button>
                                            </form>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="6" class="text-secondary">Aucun service dans votre catalogue.</td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="addServiceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content sh-card">
            <div class="modal-body p-4">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <h2 class="h5 mb-1">Ajouter un service</h2>
                        <p class="text-secondary mb-0">Choisissez un type et configurez vos infos.</p>
                    </div>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
                <form method="POST">
                    <input type="hidden" name="action" value="add_service">
                    <div class="mb-3">
                        <label class="form-label">Type de service</label>
                        <select name="service_type_id" class="form-select" required>
                            <?php foreach (($categories ?? []) as $cat): ?>
                                <?php
                                $catName = $cat["category_name"] ?? "";
                                $label = $catName !== "" ? $catName : "Autre";
                                ?>
                                <optgroup label="<?= htmlspecialchars($label) ?>">
                                    <?php foreach (($cat["services"] ?? []) as $st): ?>
                                        <option value="<?= (int)($st["id"] ?? 0) ?>">
                                            <?= htmlspecialchars($st["name"] ?? "") ?>
                                        </option>
                                    <?php endforeach; ?>
                                </optgroup>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="row g-2">
                        <div class="col-md-6">
                            <label class="form-label">Titre affiché</label>
                            <input class="form-control" type="text" name="custom_title">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Prix</label>
                            <input class="form-control" type="number" step="0.01" min="0" name="negotiated_price" value="0">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Expérience (ans)</label>
                            <input class="form-control" type="number" min="0" name="experience_years" value="0">
                        </div>
                    </div>
                    <div class="form-check mt-3">
                        <input class="form-check-input" type="checkbox" name="is_active" value="1" checked>
                        <label class="form-check-label">Actif</label>
                    </div>
                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-sh-gold">Ajouter</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editServiceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content sh-card">
            <div class="modal-body p-4">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <h2 class="h5 mb-1">Modifier un service</h2>
                        <p class="text-secondary mb-0" id="editServiceName"></p>
                    </div>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
                <form method="POST">
                    <input type="hidden" name="action" value="update_service">
                    <input type="hidden" name="service_type_id" id="editServiceId">
                    <div class="row g-2">
                        <div class="col-md-6">
                            <label class="form-label">Titre affiché</label>
                            <input class="form-control" type="text" name="custom_title" id="editCustomTitle">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Prix</label>
                            <input class="form-control" type="number" step="0.01" min="0" name="negotiated_price" id="editPrice">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Expérience (ans)</label>
                            <input class="form-control" type="number" min="0" name="experience_years" id="editExp">
                        </div>
                    </div>
                    <div class="form-check mt-3">
                        <input class="form-check-input" type="checkbox" name="is_active" value="1" id="editActive">
                        <label class="form-check-label">Actif</label>
                    </div>
                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-sh-gold">Enregistrer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const editModal = document.getElementById("editServiceModal");
        if (!editModal) return;
        editModal.addEventListener("show.bs.modal", function(event) {
            const btn = event.relatedTarget;
            if (!btn) return;
            const id = btn.getAttribute("data-id") || "";
            const name = btn.getAttribute("data-name") || "";
            const custom = btn.getAttribute("data-custom") || "";
            const price = btn.getAttribute("data-price") || "0";
            const exp = btn.getAttribute("data-exp") || "0";
            const active = btn.getAttribute("data-active") || "0";
            document.getElementById("editServiceId").value = id;
            document.getElementById("editServiceName").textContent = name;
            document.getElementById("editCustomTitle").value = custom;
            document.getElementById("editPrice").value = price;
            document.getElementById("editExp").value = exp;
            document.getElementById("editActive").checked = (active === "1");
        });
    });
</script>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>