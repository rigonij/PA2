<?php
$pageTitle = "SilverHappy • Boutique";
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

            <?php if ($status === "success"): ?>
                <div class="alert alert-success mb-3">Commande payée avec succès ! Votre panier a été vidé.</div>
            <?php elseif ($status === "cancel"): ?>
                <div class="alert alert-warning mb-3">Paiement annulé.</div>
            <?php endif; ?>

            <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
                <div>
                    <h1 class="h4 mb-1">Boutique • Articles</h1>
                    <p class="text-secondary mb-0">Panier.</p>
                </div>
                <button
                    type="button"
                    class="btn btn-sh-gold"
                    data-bs-toggle="modal"
                    data-bs-target="#cartModal"
                    style="white-space: nowrap;">
                    Panier : <?= (int)$cartTotalQty ?>
                </button>
            </div>

            <div class="row g-3">
                <?php foreach ($products as $p): ?>
                    <?php
                    $id       = (int)($p["Id_PRODUCT"] ?? 0);
                    $name     = $p["Name"] ?? "";
                    $category = $p["Category"] ?? "";
                    $price    = (float)($p["Price"] ?? 0);
                    $qty      = (int)($cartQtyByProductId[$id] ?? 0);
                    $linkImg  = $p["link_img"] ?? "";
                    ?>
                    <div class="col-md-4">
                        <div class="sh-card p-3">
                            <div class="fw-bold"><?= htmlspecialchars($name) ?></div>
                            <div class="text-secondary"><?= htmlspecialchars($category) ?></div>
                            <div class="mt-2">
                                <span class="badge badge-sh"><?= number_format($price, 2, ",", " ") ?> €</span>
                            </div>
                            <div class="mt-3 d-flex gap-2 align-items-center">
                                <?php if ($qty <= 0): ?>
                                    <a class="btn btn-sh-gold" href="boutique.php?action=add&id=<?= $id ?>">Ajouter</a>
                                <?php else: ?>
                                    <div class="d-flex gap-2 align-items-center">
                                        <a class="btn btn-outline-secondary btn-sm" href="boutique.php?action=dec&id=<?= $id ?>">-</a>
                                        <span class="fw-bold"><?= $qty ?></span>
                                        <a class="btn btn-outline-secondary btn-sm" href="boutique.php?action=add&id=<?= $id ?>">+</a>
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
                <?php if (empty($products)): ?>
                    <div class="col-12">
                        <div class="text-secondary">Aucun produit disponible.</div>
                    </div>
                <?php endif; ?>
            </div>

        </div>
    </div>
</div>

<div class="modal fade" id="cartModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content sh-card">
            <div class="modal-body p-4">

                <div class="d-flex justify-content-between align-items-start gap-3 mb-3">
                    <div>
                        <h2 class="h5 mb-1">Mon panier</h2>
                        <p class="text-secondary mb-0">
                            Total articles : <?= (int)$cartTotalQty ?> •
                            Total : <?= number_format((float)$cartTotalPrice, 2, ",", " ") ?> €
                        </p>
                    </div>
                    <div class="d-flex gap-2">
                        <?php if ($cartTotalQty > 0): ?>
                            <a class="btn btn-outline-danger"
                                href="boutique.php?action=clear"
                                onclick="return confirm('Vider le panier ?');">
                                Vider le panier
                            </a>
                        <?php endif; ?>
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                    </div>
                </div>

                <?php if (empty($cartItems)): ?>
                    <div class="text-secondary">Panier vide.</div>
                <?php else: ?>
                    <div class="table-responsive mb-3">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Article</th>
                                    <th>Prix</th>
                                    <th>Quantité</th>
                                    <th>Sous-total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($cartItems as $ci): ?>
                                    <?php
                                    $id    = (int)($ci["Id_PRODUCT"] ?? 0);
                                    $name  = $ci["Name"] ?? "";
                                    $price = (float)($ci["Price"] ?? 0);
                                    $qty   = (int)($ci["Qty"] ?? 0);
                                    $sub   = $price * $qty;
                                    ?>
                                    <tr>
                                        <td class="fw-bold"><?= htmlspecialchars($name) ?></td>
                                        <td><?= number_format($price, 2, ",", " ") ?> €</td>
                                        <td>
                                            <div class="d-flex gap-2 align-items-center">
                                                <a class="btn btn-outline-secondary btn-sm" href="boutique.php?action=dec&id=<?= $id ?>">-</a>
                                                <span class="fw-bold"><?= $qty ?></span>
                                                <a class="btn btn-outline-secondary btn-sm" href="boutique.php?action=add&id=<?= $id ?>">+</a>
                                            </div>
                                        </td>
                                        <td><?= number_format($sub, 2, ",", " ") ?> €</td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>

                    <a href="boutique.php?action=checkout" class="btn btn-sh-gold w-100">
                        Payer <?= number_format((float)$cartTotalPrice, 2, ",", " ") ?> €
                    </a>
                <?php endif; ?>

            </div>
        </div>
    </div>
</div>


<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>