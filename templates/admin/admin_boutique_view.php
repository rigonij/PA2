<?php
$pageTitle = "Admin • Boutique";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
$items = $items ?? [];
$error = $error ?? "";
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Boutique</h1>
            <p class="text-secondary mb-0">Gestion des produits.</p>
        </div>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-sh-gold" data-bs-toggle="modal" data-bs-target="#createProductModal">Nouveau produit</button>
            <a class="btn btn-outline-secondary" href="admin_dashboard.php">Retour</a>
        </div>
    </div>

    <?php if (!empty($error)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <div class="sh-card p-3">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Catégorie</th>
                        <th>Prix</th>
                        <th>Image</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <?php if (!empty($items)): ?>
                    <?php foreach ($items as $it): ?>
                        <?php
                            $id       = (int)($it["id"] ?? 0);
                            $name     = $it["name"] ?? "";
                            $category = $it["category"] ?? "";
                            $price    = (float)($it["price"] ?? 0);
                            $linkImg  = $it["link_img"] ?? "";
                        ?>
                        <tr>
                            <td>#<?= $id ?></td>
                            <td class="fw-bold"><?= htmlspecialchars($name) ?></td>
                            <td><?= htmlspecialchars($category) ?></td>
                            <td><?= number_format($price, 2, ",", " ") ?> €</td>
                            <td><?= htmlspecialchars(mb_strimwidth($linkImg, 0, 40, "...")) ?></td>
                            <td>
                                <div class="d-flex gap-2">
                                    <button type="button" class="btn btn-outline-secondary btn-sm"
                                        onclick='openEditProductModal(<?= $id ?>, <?= json_encode($name, JSON_HEX_APOS|JSON_HEX_QUOT) ?>, <?= json_encode($category, JSON_HEX_APOS|JSON_HEX_QUOT) ?>, <?= $price ?>, <?= json_encode($linkImg, JSON_HEX_APOS|JSON_HEX_QUOT) ?>)'>Éditer</button>
                                    <form method="POST" action="admin_boutique.php" onsubmit="return confirm('Supprimer ce produit ?');" class="m-0">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<?= $id ?>">
                                        <button type="submit" class="btn btn-outline-danger btn-sm">Supprimer</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                <?php else: ?>
                    <tr><td colspan="6" class="text-secondary">Aucun produit.</td></tr>
                <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="createProductModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content sh-card">
            <div class="modal-body p-4">
                <div class="d-flex justify-content-between align-items-start gap-3 mb-3">
                    <h2 class="h5 mb-0">Nouveau produit</h2>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
                <form method="POST" action="admin_boutique.php">
                    <input type="hidden" name="action" value="create">
                    <div class="mb-3">
                        <label class="form-label">Nom</label>
                        <input class="form-control" type="text" name="name" maxlength="120" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Catégorie</label>
                        <input class="form-control" type="text" name="category" maxlength="60">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Prix (€)</label>
                        <input class="form-control" type="number" step="0.01" min="0" name="price" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">URL image</label>
                        <input class="form-control" type="text" name="link_img" maxlength="255">
                    </div>
                    <button type="submit" class="btn btn-sh-gold w-100">Créer</button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editProductModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content sh-card">
            <div class="modal-body p-4">
                <div class="d-flex justify-content-between align-items-start gap-3 mb-3">
                    <h2 class="h5 mb-0">Éditer le produit</h2>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
                <form method="POST" action="admin_boutique.php">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editProductId">
                    <div class="mb-3">
                        <label class="form-label">Nom</label>
                        <input class="form-control" type="text" name="name" id="editProductName" maxlength="120" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Catégorie</label>
                        <input class="form-control" type="text" name="category" id="editProductCategory" maxlength="60">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Prix (€)</label>
                        <input class="form-control" type="number" step="0.01" min="0" name="price" id="editProductPrice" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">URL image</label>
                        <input class="form-control" type="text" name="link_img" id="editProductLinkImg" maxlength="255">
                    </div>
                    <button type="submit" class="btn btn-sh-gold w-100">Enregistrer</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
function openEditProductModal(id, name, category, price, linkImg) {
    document.getElementById("editProductId").value = id;
    document.getElementById("editProductName").value = name;
    document.getElementById("editProductCategory").value = category;
    document.getElementById("editProductPrice").value = price;
    document.getElementById("editProductLinkImg").value = linkImg;
    new bootstrap.Modal(document.getElementById("editProductModal")).show();
}
</script>

<?php include __DIR__ . "/../common/footer-scripts.php"; ?>
