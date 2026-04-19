<?php
$pageTitle = "SilverHappy • Paiement";
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
                <h1 class="h4 mb-1">Paiement Stripe (mock)</h1>
            </div>

            <div class="sh-card p-4">
                <div class="row g-3 align-items-end">
                    <div class="col-md-6">
                        <label class="form-label">Produit</label>
                        <select class="form-select" id="product">
                            <option value="Abonnement annuel - 40€">Abonnement annuel - 40€</option>
                            <option value="Renouvellement - 35€">Renouvellement - 35€</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Carte (mock)</label>
                        <input class="form-control" value="4242 4242 4242 4242" />
                    </div>
                    <div class="col-md-3">
                        <button class="btn btn-sh-primary w-100" type="button" onclick="payMock()">Payer (mock)</button>
                    </div>
                </div>

                <hr class="my-4" />

                <div class="alert alert-success d-none" id="ok">
                    Paiement simulé OK. Abonnement renouvelé (mock).
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function payMock() {
        document.getElementById("ok").classList.remove("d-none");
        localStorage.setItem("sh_last_payment", new Date().toISOString());
    }
</script>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>