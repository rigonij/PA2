<?php $pageTitle = "Admin • Categories";
$isAdminUi = true;
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php"; ?>

<div class="container py-4">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h1 class="h4 mb-0">Categories et types de service</h1>
        <a href="admin_dashboard.php" class="btn btn-outline-secondary btn-sm">Retour dashboard</a>
    </div>

    <?php if (!empty($success)): ?>
        <div class="alert alert-success"><?= htmlspecialchars($success) ?></div>
    <?php endif; ?>
    <?php if (!empty($error)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <div class="sh-card p-4 mb-4">
        <h2 class="h5 mb-3">Categories</h2>
        <form method="POST" class="row g-2 align-items-end mb-3">
            <input type="hidden" name="action" value="cat_add">
            <div class="col-md-9">
                <label class="form-label small mb-1">Nouvelle categorie</label>
                <input type="text" name="name" class="form-control" placeholder="Nom de la categorie" required>
            </div>
            <div class="col-md-3">
                <button type="submit" class="btn btn-sh-gold w-100">Ajouter</button>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                    <tr><th style="width:80px;">ID</th><th>Nom</th><th style="width:280px;">Actions</th></tr>
                </thead>
                <tbody>
                <?php foreach ($categories as $c): ?>
                    <tr>
                        <form method="POST">
                            <td><?= (int)$c["id"] ?></td>
                            <td>
                                <input type="hidden" name="id" value="<?= (int)$c["id"] ?>">
                                <input type="text" name="name" class="form-control form-control-sm" value="<?= htmlspecialchars($c["name"]) ?>" required>
                            </td>
                            <td class="d-flex gap-2">
                                <button type="submit" name="action" value="cat_edit" class="btn btn-sm btn-outline-primary">Enregistrer</button>
                                <button type="submit" name="action" value="cat_del" class="btn btn-sm btn-outline-danger" onclick="return confirm('Supprimer cette categorie ?');">Supprimer</button>
                            </td>
                        </form>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($categories)): ?>
                    <tr><td colspan="3" class="text-secondary text-center">Aucune categorie.</td></tr>
                <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>

    <div class="sh-card p-4">
        <h2 class="h5 mb-3">Types de service</h2>
        <form method="POST" class="row g-2 align-items-end mb-3">
            <input type="hidden" name="action" value="type_add">
            <div class="col-md-3">
                <label class="form-label small mb-1">Nom</label>
                <input type="text" name="name" class="form-control" required>
            </div>
            <div class="col-md-3">
                <label class="form-label small mb-1">Categorie</label>
                <select name="category_id" class="form-select" required>
                    <option value="">--</option>
                    <?php foreach ($categories as $c): ?>
                        <option value="<?= (int)$c["id"] ?>"><?= htmlspecialchars($c["name"]) ?></option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label small mb-1">Prix horaire (EUR)</label>
                <input type="number" step="0.01" min="0" name="price" class="form-control" value="0.00">
            </div>
            <div class="col-md-2">
                <label class="form-label small mb-1">Duree (min)</label>
                <input type="number" min="1" name="duration_min" class="form-control" value="60">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-sh-gold w-100">Ajouter</button>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                    <tr><th style="width:70px;">ID</th><th>Nom</th><th>Categorie</th><th style="width:130px;">Prix (EUR)</th><th style="width:120px;">Duree (min)</th><th style="width:260px;">Actions</th></tr>
                </thead>
                <tbody>
                <?php foreach ($serviceTypes as $t): ?>
                    <tr>
                        <form method="POST">
                            <td><?= (int)$t["id"] ?></td>
                            <td>
                                <input type="hidden" name="id" value="<?= (int)$t["id"] ?>">
                                <input type="text" name="name" class="form-control form-control-sm" value="<?= htmlspecialchars($t["name"]) ?>" required>
                            </td>
                            <td>
                                <select name="category_id" class="form-select form-select-sm" required>
                                    <?php foreach ($categories as $c): ?>
                                        <option value="<?= (int)$c["id"] ?>" <?= ((int)$c["id"] === (int)$t["category_id"]) ? "selected" : "" ?>><?= htmlspecialchars($c["name"]) ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </td>
                            <td><input type="number" step="0.01" min="0" name="price" class="form-control form-control-sm" value="<?= htmlspecialchars(number_format((float)$t["price"], 2, ".", "")) ?>"></td>
                            <td><input type="number" min="1" name="duration_min" class="form-control form-control-sm" value="<?= (int)$t["duration_min"] ?>"></td>
                            <td class="d-flex gap-2">
                                <button type="submit" name="action" value="type_edit" class="btn btn-sm btn-outline-primary">Enregistrer</button>
                                <button type="submit" name="action" value="type_del" class="btn btn-sm btn-outline-danger" onclick="return confirm('Supprimer ce type ?');">Supprimer</button>
                            </td>
                        </form>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($serviceTypes)): ?>
                    <tr><td colspan="6" class="text-secondary text-center">Aucun type.</td></tr>
                <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
