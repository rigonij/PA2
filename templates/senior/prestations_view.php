<?php
$pageTitle = "SilverHappy • Prestations";
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
                <h1 class="h4 mb-1">Catalogue • Services</h1>
            </div>

            <div class="sh-card p-3 mb-4">
                <div class="row g-2 align-items-end">
                    <div class="col-md-6">
                        <label class="form-label">Recherche</label>
                        <input type="text" id="searchInput" class="form-control" placeholder="Ex: aide à domicile" />
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Catégorie</label>
                        <select class="form-select">
                            <option>Toutes</option>
                            <option>Bien-Être</option>
                            <option>Santé</option>
                            <option>Services à Domicile</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button class="btn btn-sh-primary w-100" type="button">Filtrer (mock)</button>
                    </div>
                </div>
            </div>

            <div id="catalogContainer">
                <?php foreach ($categories as $categoryName => $providers): ?>
                    <section class="category-section mb-4">
                        <h2 class="h5 fw-bold mb-3" style="color: var(--sh-blue-700);"><?= htmlspecialchars($categoryName) ?></h2>

                        <div class="slider-container" style="display: flex; align-items: center; position: relative; padding: 0 50px;">

                            <button class="btn btn-light arrow-btn left-arrow" style="position: absolute; left: 0; z-index: 10; border-radius: 50%; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 5px rgba(0,0,0,0.2); padding: 0;">
                                <i class="bi bi-chevron-left fs-5"></i>
                            </button>

                            <div class="cards-wrapper" style="display: flex; overflow-x: hidden; scroll-behavior: smooth; gap: 1rem; width: 100%; padding: 10px 0;">
                                <?php foreach ($providers as $provider): ?>
                                    <div class="sh-card provider-card" style="min-width: 240px; overflow: hidden; border: 1px solid #e0e0e0; border-radius: 12px;">

                                        <?php
                                        $dbImg = !empty($provider['link_img']) ? $provider['link_img'] : 'public/assets/img/provider/default.png';
                                        $absoluteImgPath = '/PA_2i2/' . $dbImg;
                                        ?>
                                        <div style="height: 140px; background-color: #e9ecef; background-image: url('<?= htmlspecialchars($absoluteImgPath) ?>'); background-size: cover; background-position: center;">
                                        </div>

                                        <div class="p-3" style="background-color: var(--sh-blue); color: white;">
                                            <div class="fw-bold text-center mb-2"><?= htmlspecialchars($provider['Company_Name']) ?></div>
                                            <div class="d-flex justify-content-center gap-2">
                                                <a href="profil.php?id=<?= $provider['Id_USER'] ?>" class="btn btn-outline-light btn-sm" style="font-size: 0.8rem;">Voir le profil</a>
                                                <button
                                                    class="btn btn-outline-light btn-sm"
                                                    style="font-size: 0.8rem;"
                                                    type="button"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#reserveServiceModal"
                                                    onclick="openReserveModal(
                                                    <?= (int)$provider['Id_SERVICE_TYPE'] ?>,
                                                    <?= (int)$provider['Id_USER'] ?>,
                                                    '<?= htmlspecialchars($provider['Company_Name'], ENT_QUOTES) ?>',
                                                    '<?= htmlspecialchars($provider['ServiceName'], ENT_QUOTES) ?>'
                                                )">
                                                    Réserver
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                <?php endforeach; ?>
                            </div>

                            <button class="btn btn-light arrow-btn right-arrow" style="position: absolute; right: 0; z-index: 10; border-radius: 50%; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 5px rgba(0,0,0,0.2); padding: 0;">
                                <i class="bi bi-chevron-right fs-5"></i>
                            </button>
                        </div>
                    </section>
                <?php endforeach; ?>
            </div>

        </div>
    </div>
</div>

<script>
    document.querySelectorAll('.category-section').forEach(section => {
        const wrapper = section.querySelector('.cards-wrapper');
        const leftBtn = section.querySelector('.left-arrow');
        const rightBtn = section.querySelector('.right-arrow');

        leftBtn.addEventListener('click', () => wrapper.scrollBy({
            left: -260,
            behavior: 'smooth'
        }));
        rightBtn.addEventListener('click', () => wrapper.scrollBy({
            left: 260,
            behavior: 'smooth'
        }));
    });
</script>

<script>
    const searchInput = document.getElementById('searchInput');
    const catalogContainer = document.getElementById('catalogContainer');


    searchInput.addEventListener('input', function(e) {
        const query = e.target.value.trim();

        fetch(`api_search.php?q=${encodeURIComponent(query)}`)
            .then(reponse => reponse.json())
            .then(data => {

                catalogContainer.innerHTML = '';

                if (Object.keys(data).length === 0) {
                    catalogContainer.innerHTML = '<p class="text-muted mt-4">Aucun service ou prestataire trouvé pour cette recherche.</p>';
                    return;
                }

                for (const [categoryName, providers] of Object.entries(data)) {
                    let html = `
                <section class="category-section mb-4">
                    <h2 class="h5 fw-bold mb-3" style="color: var(--sh-blue-700);">${categoryName}</h2>
                    <div class="cards-wrapper" style="display: flex; flex-wrap: wrap; gap: 1rem; width: 100%; padding: 10px 0;">`;

                    providers.forEach(provider => {
                        const imgPath = provider.link_img ? `/SilverHappy/${provider.link_img}` : '/SilverHappy/public/assets/img/provider/default.png';

                        html += `
                        <div class="sh-card provider-card" style="min-width: 240px; overflow: hidden; border: 1px solid #e0e0e0; border-radius: 12px;">   
                            <div style="height: 140px; background-color: #e9ecef; background-image: url('${imgPath}'); background-size: cover; background-position: center;"></div>
                            <div class="p-3" style="background-color: var(--sh-blue); color: white;">
                                <div class="fw-bold text-center mb-2">${provider.Company_Name}</div>
                                <div class="text-center small mb-2 text-light">${provider.ServiceName}</div>
                                <div class="d-flex justify-content-center gap-2">
                                    <a href="profil.php?id=${provider.Id_USER}" class="btn btn-outline-light btn-sm" style="font-size: 0.8rem;">Voir le profil</a>
                                </div>
                            </div>
                        </div>`;
                    });

                    html += `</div></section>`;

                    catalogContainer.innerHTML += html;
                }
            })
            .catch(error => {
                console.error("Les gars, l'appel à l'API a échoué :", error);
            });

    });
</script>

<div class="modal fade" id="reserveServiceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content sh-card">
            <form method="POST" action="prestations.php">
                <div class="modal-body p-4">
                    <h2 class="h5 mb-1">Réserver un service</h2>
                    <p class="text-secondary small mb-3" id="reserveSubtitle"></p>

                    <input type="hidden" name="action" value="reserve_service">
                    <input type="hidden" name="service_type_id" id="serviceTypeId">
                    <input type="hidden" name="provider_id" id="providerId">

                    <div class="mb-3">
                        <input type="hidden" name="start_at" id="startAt">

                        <div class="mb-3">
                            <label class="form-label">Date</label>
                            <input class="form-control" type="date" id="slotDate" required>
                            <div class="form-text">Choisis un jour, puis sélectionne un créneau.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Créneau disponible</label>
                            <select class="form-select" id="slotSelect" required disabled>
                                <option value="">Choisir une date d’abord…</option>
                            </select>
                            <div class="form-text" id="slotHint"></div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Commentaire (optionnel)</label>
                        <textarea class="form-control" name="comment" rows="3" placeholder="Ex: besoin d’aide pour..."></textarea>
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-sh-primary">Confirmer</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    let currentServiceTypeId = 0;
    let currentProviderId = 0;

    function openReserveModal(serviceTypeId, providerId, companyName, serviceName) {
        currentServiceTypeId = serviceTypeId;
        currentProviderId = providerId;

        document.getElementById("serviceTypeId").value = serviceTypeId;
        document.getElementById("providerId").value = providerId;
        document.getElementById("reserveSubtitle").textContent = serviceName + " • " + companyName;

        document.getElementById("slotDate").value = "";
        document.getElementById("slotSelect").innerHTML = '<option value="">Choisir une date d’abord…</option>';
        document.getElementById("slotSelect").disabled = true;
        document.getElementById("startAt").value = "";
        document.getElementById("slotHint").textContent = "";
    }

    async function loadSlots() {
        const date = document.getElementById("slotDate").value;
        const select = document.getElementById("slotSelect");
        const hint = document.getElementById("slotHint");

        select.disabled = true;
        select.innerHTML = '<option value="">Chargement…</option>';
        hint.textContent = "";
        document.getElementById("startAt").value = "";

        if (!date) {
            select.innerHTML = '<option value="">Choisir une date d’abord…</option>';
            return;
        }

        const url = `api_slots.php?service_type_id=${encodeURIComponent(currentServiceTypeId)}&provider_id=${encodeURIComponent(currentProviderId)}&date=${encodeURIComponent(date)}`;

        const res = await fetch(url);
        const data = await res.json();

        if (!data.success) {
            select.innerHTML = '<option value="">Erreur</option>';
            hint.textContent = data.message || "Erreur chargement créneaux.";
            return;
        }

        const slots = data.slots || [];
        if (slots.length === 0) {
            select.innerHTML = '<option value="">Aucun créneau disponible</option>';
            hint.textContent = "Essaye une autre date (ou le prestataire n’a pas mis d’horaires).";
            return;
        }

        select.innerHTML = '<option value="">Sélectionner un créneau…</option>';
        slots.forEach(s => {
            const start = s.start_at || "";
            const end = s.end_at || "";
            const label = `${start.substring(11,16)} - ${end.substring(11,16)}`;

            const opt = document.createElement("option");
            opt.value = start;
            opt.textContent = label;
            select.appendChild(opt);
        });

        select.disabled = false;
    }

    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("slotDate").addEventListener("change", loadSlots);

        document.getElementById("slotSelect").addEventListener("change", function(e) {
            document.getElementById("startAt").value = e.target.value || "";
        });
    });
</script>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>