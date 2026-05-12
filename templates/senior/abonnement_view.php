<?php if (isset($_GET['status']) && $_GET['status'] === 'unsubscribed'): ?>
<div class="alert alert-info">Desinscription enregistree. Acces actif jusqu a la fin de la periode en cours.</div>
<?php endif; ?>
<?php $pageTitle = "SilverHappy • Abonnement";
$isSeniorUi = true;
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php"; ?>

<div class="container py-4">
  <?php include __DIR__ . "/../common/topbar.php"; ?>
  <div class="row g-3">
    <div class="col-lg-3"><?php include __DIR__ . "/../common/sidebar.php"; ?></div>
    <div class="col-lg-9">
      <?php if ($status === "success"): ?>
        <div class="alert alert-success">Abonnement active avec succes !</div>
      <?php elseif ($status === "cancel"): ?>
        <div class="alert alert-warning">Paiement annule.</div>
      <?php elseif ($status === "unsubscribed"): ?>
        <?php endif; ?>
      <?php if (!empty($error)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
      <?php endif; ?>

      <div class="sh-card p-4 mb-3"><h1 class="h4 mb-1">Abonnement et renouvellement</h1></div>

      <div class="row g-3">
        <div class="col-md-6">
          <div class="sh-card p-4">
            <div class="d-flex align-items-center justify-content-between mb-2">
              <div class="fw-bold">Abonnement actuel</div>
              <?php $isActive = !empty($subscription) && !empty($subscription['in_period']); $isReallyActive = !empty($subscription) && !empty($subscription['is_active']); ?>
              <?php if ($isReallyActive): ?>
                            <span class="badge text-bg-success">Actif</span>
                        <?php elseif ($isActive): ?>
                            <span class="badge text-bg-warning">Désinscrit (jusqu'au <?= htmlspecialchars($subscription["end_date"] ?? "") ?>)</span>
                        <?php else: ?>
                            <span class="badge text-bg-secondary">Inactif</span>
                        <?php endif; ?>
            </div>

            <?php if ($isActive): ?>
              <ul class="text-secondary mb-3">
                <li>Type : <?= htmlspecialchars($subscription["name"]) ?></li>
                <?php if (!empty($subscription["end_date"])): ?>
                  <li>Renouvellement : <?= htmlspecialchars($subscription["end_date"]) ?></li>
                <?php endif; ?>
              </ul>
              <div class="d-flex flex-column gap-2 mb-2">
                <button type="button" class="btn btn-outline-secondary w-100" data-bs-toggle="modal" data-bs-target="#detailsModal">Details</button>
                <?php if ($isReallyActive): ?><form method="POST" onsubmit="return confirm('Confirmer la desinscription ?');">
                            <input type="hidden" name="action" value="cancel">
                            <button type="submit" class="btn btn-outline-danger w-100">Se desinscrire</button>
                        </form>
                        <?php endif; ?>
              </div>
            <?php else: ?>
              <p class="text-secondary mb-3">Aucun abonnement actif.</p>
            <?php endif; ?>

            <?php
              $normalPlans = []; $renewalPlans = [];
              foreach (($plans ?? []) as $pl) {
                if (strpos($pl["name"], "renewal") !== false) $renewalPlans[] = $pl;
                else $normalPlans[] = $pl;
              }
            ?>
            <?php if (!$isActive): ?>
            <div class="d-flex flex-column gap-2">
              <?php if (!empty($normalPlans)): ?>
                <div class="fw-semibold small text-secondary mb-1">Abonnement normal :</div>
                <?php foreach ($normalPlans as $pl): ?>
                  <form method="POST">
                    <input type="hidden" name="plan" value="<?= htmlspecialchars($pl["name"]) ?>">
                    <button class="btn btn-sh-gold w-100"><?= htmlspecialchars($pl["display_name"] ?: $pl["name"]) ?> &mdash; <?= number_format($pl["price"], 2, ",", " ") ?> &euro;</button>
                  </form>
                <?php endforeach; ?>
              <?php endif; ?>
              <?php if (!empty($renewalPlans)): ?>
                <div class="fw-semibold small text-secondary mb-1 mt-2">Renouvellement :</div>
                <?php foreach ($renewalPlans as $pl): ?>
                  <form method="POST">
                    <input type="hidden" name="plan" value="<?= htmlspecialchars($pl["name"]) ?>">
                    <button class="btn btn-outline-warning w-100"><?= htmlspecialchars($pl["display_name"] ?: $pl["name"]) ?> &mdash; <?= number_format($pl["price"], 2, ",", " ") ?> &euro;</button>
                  </form>
                <?php endforeach; ?>
              <?php endif; ?>
            </div>
            <?php endif; ?>
          </div>
        </div>

        <div class="col-md-6">
          <div class="sh-card p-4">
            <div class="fw-bold mb-2">Historique des paiements</div>
            <div class="table-responsive">
              <table class="table align-middle mb-0">
                <thead><tr><th>Date</th><th>Type</th><th>Montant</th><th>Statut</th></tr></thead>
                <tbody>
                  <?php if (empty($payments)): ?>
                    <tr><td colspan="4" class="text-secondary text-center">Aucun paiement.</td></tr>
                  <?php else: ?>
                    <?php foreach ($payments as $p): ?>
                      <tr>
                        <td><?= htmlspecialchars($p["date"]) ?></td>
                        <td><?= htmlspecialchars($p["type_label"]) ?></td>
                        <td><?= number_format($p["amount_euros"], 2, ",", " ") ?> &euro;</td>
                        <td><span class="badge text-bg-success">Paye</span></td>
                      </tr>
                    <?php endforeach; ?>
                  <?php endif; ?>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<?php if ($isActive): ?>
<div class="modal fade" id="detailsModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">Details de votre abonnement</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <div class="modal-body">
        <p><strong>Type actuel :</strong> <?= htmlspecialchars($subscription["name"]) ?></p>
        <p><strong>Prix paye lors de la souscription :</strong> <?= number_format(($subscription["paid_price_cents"] ?? 0)/100, 2, ",", " ") ?> &euro;</p>
        <p><strong>Date du prochain renouvellement :</strong> <?= htmlspecialchars($subscription["end_date"] ?? "") ?></p>
        <p><strong>Prix du prochain paiement :</strong> <?= number_format(($subscription["next_renewal_price_cents"] ?? 0)/100, 2, ",", " ") ?> &euro;
          <span class="text-secondary small">(tarif <?= ($subscription["duration_months"] ?? 1) == 12 ? "annuel" : "mensuel" ?> renouvellement<?= !empty($subscription["next_renewal_label"]) ? " &mdash; " . htmlspecialchars($subscription["next_renewal_label"]) : "" ?>)</span>
        </p>
      </div>
      <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button></div>
    </div>
  </div>
</div>
<?php endif; ?>

<?php if (!empty($notifications)): ?>
<div class="modal fade" id="priceChangeModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">Changement de tarif</h5></div>
      <div class="modal-body">
        <p>Le tarif a ete mis a jour par l administrateur :</p>
        <ul>
          <?php foreach ($notifications as $n): ?>
            <li><strong><?= htmlspecialchars($n["new_display_name"] ?: $n["old_display_name"]) ?></strong> :
              <span class="text-decoration-line-through text-secondary"><?= number_format($n["old_price_cents"]/100, 2, ",", " ") ?> &euro;</span>
              &rarr;
              <strong><?= number_format($n["new_price_cents"]/100, 2, ",", " ") ?> &euro;</strong>
            </li>
          <?php endforeach; ?>
        </ul>
        <p class="text-secondary small">Au prochain renouvellement, le nouveau tarif sera applique. Les paiements deja effectues restent inchanges dans l historique.</p>
      </div>
      <div class="modal-footer">
        <form method="POST">
          <input type="hidden" name="action" value="ack_notifications">
          <button type="submit" class="btn btn-sh-gold">OK, compris</button>
        </form>
      </div>
    </div>
  </div>
</div>
<script>
document.addEventListener("DOMContentLoaded", function() {
  var el = document.getElementById("priceChangeModal");
  if (el && window.bootstrap) { new bootstrap.Modal(el).show(); }
});
</script>
<?php endif; ?>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>
