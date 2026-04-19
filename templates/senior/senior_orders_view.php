<?php
$pageTitle = "SilverHappy • Mes commandes";
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
                <h1 class="h4 mb-1">Mes commandes</h1>
            </div>

            <?php if (empty($orders)): ?>
                <div class="sh-card p-4 text-center text-muted">
                    Vous n'avez pas encore passé de commande.
                </div>
            <?php else: ?>
                <?php foreach ($orders as $order): ?>
                    <?php
                    $orderId   = (int)($order["id"] ?? 0);
                    $status    = $order["status"] ?? "";
                    $total     = (int)($order["amount_total"] ?? 0);
                    $createdAt = $order["created_at"] ?? "";
                    $items     = $order["items"] ?? [];

                    $date = "";
                    if ($createdAt) {
                        $dt   = new DateTime($createdAt);
                        $date = $dt->format("d/m/Y à H:i");
                    }

                    $badgeClass = "badge bg-secondary text-white";
                    if ($status === "paid")      $badgeClass = "badge bg-success text-white";
                    elseif ($status === "pending")   $badgeClass = "badge bg-warning text-dark";
                    elseif ($status === "cancelled") $badgeClass = "badge bg-danger text-white";

                    $statusLabel = match ($status) {
                        "paid"      => "Payée",
                        "pending"   => "En attente",
                        "cancelled" => "Annulée",
                        default     => ucfirst($status),
                    };
                    ?>
                    <div class="sh-card p-4 mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <span class="fw-bold">Commande #<?= $orderId ?></span>
                                <span class="text-muted ms-2 small"><?= htmlspecialchars($date) ?></span>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <span class="<?= $badgeClass ?>"><?= $statusLabel ?></span>
                                <span class="fw-bold"><?= number_format($total / 100, 2, ",", " ") ?> €</span>
                            </div>
                        </div>

                        <?php if (!empty($items)): ?>
                            <table class="table table-sm mb-0">
                                <thead>
                                    <tr>
                                        <th>Produit</th>
                                        <th>Prix unitaire</th>
                                        <th>Qté</th>
                                        <th>Sous-total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($items as $item): ?>
                                        <?php
                                        $name       = $item["name"] ?? "";
                                        $priceCents = (int)($item["price_cents"] ?? 0);
                                        $qty        = (int)($item["qty"] ?? 1);
                                        $sub        = $priceCents * $qty;
                                        ?>
                                        <tr>
                                            <td><?= htmlspecialchars($name) ?></td>
                                            <td><?= number_format($priceCents / 100, 2, ",", " ") ?> €</td>
                                            <td><?= $qty ?></td>
                                            <td><?= number_format($sub / 100, 2, ",", " ") ?> €</td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        <?php endif; ?>
                    </div>
                <?php endforeach; ?>
            <?php endif; ?>

        </div>
    </div>
</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>