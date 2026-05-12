<?php $pageTitle = "Admin • Abonnements";
$isAdminUi = true;
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php"; ?>

<div class="container py-4">
  <div class="d-flex align-items-center justify-content-between mb-3">
    <h1 class="h4 mb-0">Gestion des plans d'abonnement</h1>
    <a href="admin_dashboard.php" class="btn btn-outline-secondary btn-sm">Retour dashboard</a>
  </div>

  <?php if (!empty($success)): ?>
    <div class="alert alert-success"><?= htmlspecialchars($success) ?></div>
  <?php endif; ?>
  <?php if (!empty($error)): ?>
    <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
  <?php endif; ?>

  <div class="sh-card p-4">
    <p class="text-secondary small mb-3">
</p>

    <div class="table-responsive">
      <table class="table align-middle">
        <thead>
          <tr>
            <th style="width:22%">Type (fixe)</th>
            <th style="width:30%">Nom affiché</th>
            <th style="width:18%">Prix (€)</th>
            <th style="width:18%">Durée (mois)</th>
            <th style="width:12%"></th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($plans as $p): ?>
            <?php $typeLabel = $typeLabels[$p["name"]] ?? $p["name"]; ?>
            <tr>
              <form method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<?= (int)$p["id"] ?>">
                <td><span class="fw-semibold"><?= htmlspecialchars($typeLabel) ?></span><br>
                  <small class="text-secondary"><?= htmlspecialchars($p["name"]) ?></small></td>
                <td><input type="text" class="form-control" name="display_name" value="<?= htmlspecialchars($p["display_name"]) ?>" required></td>
                <td><input type="number" step="0.01" min="0" class="form-control" name="price" value="<?= htmlspecialchars(number_format((float)$p["price"], 2, ".", "")) ?>" required></td>
                <td><input type="number" min="1" class="form-control" name="duration_months" value="<?= (int)$p["duration_months"] ?>" required></td>
                <td><button class="btn btn-sh-gold w-100">Enregistrer</button></td>
              </form>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>
