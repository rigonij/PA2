<?php
function renderFacturation(array $invoices): void
{
    $pageTitle = "SilverHappy • Mes factures";
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
                    <h1 class="h4 mb-1">Facturation &amp; archivage PDF</h1>
                    <p class="text-secondary mb-0">Téléchargement PDF.</p>
                </div>

                <div class="sh-card p-4">
                    <?php if (empty($invoices)): ?>
                        <p class="text-secondary">Aucune facture disponible.</p>
                    <?php else: ?>
                        <table class="table table-borderless align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Réf</th>
                                    <th>Date</th>
                                    <th>Objet</th>
                                    <th>Montant</th>
                                    <th>PDF</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($invoices as $inv): ?>
                                    <?php
                                    $ref    = htmlspecialchars($inv["ref"]    ?? "");
                                    $date   = htmlspecialchars($inv["date"]   ?? "");
                                    $label  = htmlspecialchars($inv["label"]  ?? "");
                                    $amount = number_format((float)($inv["amount"] ?? 0), 2, ",", " ");
                                    $type   = urlencode($inv["type"] ?? "");
                                    $id     = (int)($inv["id"] ?? 0);
                                    ?>
                                    <tr>
                                        <td><?= $ref ?></td>
                                        <td><?= $date ?></td>
                                        <td><?= $label ?></td>
                                        <td><?= $amount ?> €</td>
                                        <td>
                                            <a class="btn btn-sh-gold btn-sm fw-bold"
                                                href="senior_facture_pdf.php?type=<?= $type ?>&id=<?= $id ?>"
                                                target="_blank">
                                                Télécharger
                                            </a>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    <?php endif; ?>
                </div>

            </div>
        </div>
    </div>
<?php
    include __DIR__ . "/../common/footer.php";
    include __DIR__ . "/../common/footer-scripts.php";
}
