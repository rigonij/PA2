<?php
$pageTitle = "SilverHappy • Prestations";
$isSeniorUi = true;
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$categories = $categories ?? [];
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
                        <input type="text" class="form-control" id="catalogSearch" placeholder="Ex: aide à domicile">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Catégorie</label>
                        <select class="form-select" id="catalogCategory">
                            <option value="">Toutes</option>
                            <?php foreach (array_keys($categories ?? []) as $cat): ?>
                                <option value="<?= htmlspecialchars($cat) ?>"><?= htmlspecialchars($cat) ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="button" class="btn btn-sh-gold w-100" id="catalogSearchBtn">Rechercher</button>
                    </div>
                </div>
                <div id="catalogNoResults" class="text-secondary mt-3" style="display:none;">Aucun prestataire trouvé.</div>
            </div>
            <div id="catalogContainer">
                <?php foreach ($categories as $categoryName => $providers): ?>
                    <section class="category-section mb-4" data-category="<?= htmlspecialchars($categoryName) ?>">
                        <h2 class="h5 fw-bold mb-3" style="color: var(--sh-blue-700);"><?= htmlspecialchars($categoryName) ?></h2>
                        <div class="slider-container" style="display: flex; align-items: center; position: relative; padding: 0 50px;">
                            <button class="btn btn-light arrow-btn left-arrow" style="position: absolute; left: 0; z-index: 10; border-radius: 50%; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 5px rgba(0,0,0,0.2); padding: 0;">
                                <i class="bi bi-chevron-left fs-5"></i>
                            </button>
                            <div class="cards-wrapper" style="display: flex; overflow-x: hidden; scroll-behavior: smooth; gap: 1rem; width: 100%; padding: 10px 0;">
                                <?php foreach ($providers as $provider): ?>
                                    <div class="sh-card provider-card" data-search="<?= htmlspecialchars(strtolower(($provider['Company_Name'] ?? '') . ' ' . ($provider['ServiceName'] ?? ''))) ?>" style="min-width: 240px; overflow: hidden; border: 1px solid #e0e0e0; border-radius: 12px;">
                                        <?php
                                        $dbImg = !empty($provider['link_img']) ? $provider['link_img'] : 'public/assets/img/provider/default.png';
                                        $absoluteImgPath = '/PA_2i2/' . $dbImg;
                                        ?>
                                        <div style="height: 140px; background-color: #e9ecef; background-image: url('<?= htmlspecialchars($absoluteImgPath) ?>'); background-size: cover; background-position: center;">
                                        </div>
                                        <div class="p-3" style="background-color: var(--sh-blue); color: white;">
                                            <div class="fw-bold text-center"><?= htmlspecialchars($provider['ServiceName'] ?? '') ?></div>
                                        <div class="text-center small opacity-75 mb-1"><?= htmlspecialchars($categoryName) ?></div>
                                        <div class="text-center small mb-2"><?= htmlspecialchars($provider['Company_Name'] ?? '') ?></div>
                                            <div class="d-flex justify-content-center gap-2">
                                                <button
                                                    class="btn btn-outline-light btn-sm"
                                                    style="font-size: 0.8rem;"
                                                    type="button"
                                                    onclick="openDetailModal(<?= (int)$provider['Id_SERVICE_TYPE'] ?>, <?= (int)$provider['Id_USER'] ?>)">
                                                    Détail
                                                </button>
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
    function applyCatalogFilter() {
        const query = (document.getElementById('catalogSearch').value || '').trim().toLowerCase();
        const selectedCat = document.getElementById('catalogCategory').value || '';
        let totalVisible = 0;

        document.querySelectorAll('.category-section').forEach(function(section) {
            const sectionCat = section.getAttribute('data-category') || '';
            const catMatch = !selectedCat || sectionCat === selectedCat;

            let sectionVisibleCount = 0;
            section.querySelectorAll('.provider-card').forEach(function(card) {
                const blob = card.getAttribute('data-search') || '';
                const textMatch = !query || blob.indexOf(query) !== -1;
                const visible = catMatch && textMatch;
                card.style.display = visible ? '' : 'none';
                if (visible) sectionVisibleCount++;
            });

            section.style.display = sectionVisibleCount > 0 ? '' : 'none';
            totalVisible += sectionVisibleCount;
        });

        document.getElementById('catalogNoResults').style.display = totalVisible === 0 ? 'block' : 'none';
    }

    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('catalogSearchBtn').addEventListener('click', applyCatalogFilter);
        document.getElementById('catalogCategory').addEventListener('change', applyCatalogFilter);
        document.getElementById('catalogSearch').addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                applyCatalogFilter();
            }
        });
    });
</script>

<div class="modal fade" id="detailServiceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content sh-card">
            <div class="modal-body p-4">
                <div id="detailLoading" class="text-center text-secondary py-5">Chargement…</div>
                <div id="detailContent" style="display:none;">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <h2 class="h4 mb-1" id="detailServiceName"></h2>
                            <div class="text-secondary small" id="detailCategory"></div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <div class="border rounded p-3 h-100">
                                <div class="text-secondary small mb-1">Tarif</div>
                                <div class="h5 mb-0" id="detailPrice"></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="border rounded p-3 h-100">
                                <div class="text-secondary small mb-1">Note moyenne</div>
                                <div class="h5 mb-0" id="detailRating"></div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3" id="detailCustomTitleWrap" style="display:none;">
                        <div class="text-secondary small mb-1">Description du service</div>
                        <div id="detailCustomTitle"></div>
                    </div>

                    <div class="mb-3" id="detailExperienceWrap" style="display:none;">
                        <div class="text-secondary small mb-1">Expérience</div>
                        <div id="detailExperience"></div>
                    </div>

                    <hr>

                    <h3 class="h6 mb-2">Prestataire</h3>
                    <div class="mb-1 fw-bold" id="detailCompany"></div>
                    <div class="mb-2 text-secondary small" id="detailProviderName"></div>
                    <div class="mb-3" id="detailProviderDescWrap" style="display:none;">
                        <div id="detailProviderDesc" class="text-secondary"></div>
                    </div>

                    <hr>

                    <h3 class="h6 mb-2">Avis</h3>
                    <div id="detailReviewsList"></div>

                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                        <button type="button" class="btn btn-sh-primary" id="detailReserveBtn">Réserver</button>
                    </div>
                </div>
                <div id="detailError" class="alert alert-danger" style="display:none;"></div>
            </div>
        </div>
    </div>
</div>

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
                                <option value="">Choisir une date d'abord…</option>
                            </select>
                            <div class="form-text" id="slotHint"></div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Commentaire (optionnel)</label>
                        <textarea class="form-control" name="comment" rows="3" placeholder="Ex: besoin d'aide pour..."></textarea>
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
    let detailModalInstance = null;
    let reserveModalInstance = null;
    let pendingReserve = null;

    function openReserveModal(serviceTypeId, providerId, companyName, serviceName) {
        currentServiceTypeId = serviceTypeId;
        currentProviderId = providerId;
        document.getElementById("serviceTypeId").value = serviceTypeId;
        document.getElementById("providerId").value = providerId;
        document.getElementById("reserveSubtitle").textContent = serviceName + " • " + companyName;
        document.getElementById("slotDate").value = "";
        document.getElementById("slotSelect").innerHTML = '<option value="">Choisir une date d\'abord…</option>';
        document.getElementById("slotSelect").disabled = true;
        document.getElementById("startAt").value = "";
        document.getElementById("slotHint").textContent = "";
    }

    async function openDetailModal(serviceTypeId, providerId) {
        const modalEl = document.getElementById("detailServiceModal");
        if (!detailModalInstance) detailModalInstance = new bootstrap.Modal(modalEl);

        document.getElementById("detailLoading").style.display = "block";
        document.getElementById("detailContent").style.display = "none";
        document.getElementById("detailError").style.display = "none";

        detailModalInstance.show();

        try {
            const res = await fetch(`api_service_details.php?service_type_id=${serviceTypeId}&provider_id=${providerId}`);
            const data = await res.json();

            if (!data.success) {
                document.getElementById("detailLoading").style.display = "none";
                const errEl = document.getElementById("detailError");
                errEl.textContent = data.message || "Erreur chargement";
                errEl.style.display = "block";
                return;
            }

            const s = data.service;
            const p = data.provider;
            const stats = data.stats;

            document.getElementById("detailServiceName").textContent = s.name;
            document.getElementById("detailCategory").textContent = s.category;
            document.getElementById("detailPrice").textContent = Number(s.price).toFixed(2).replace(".", ",") + " € / h";

            if (stats.rating_count > 0) {
                document.getElementById("detailRating").textContent = stats.rating_avg + " / 5 (" + stats.rating_count + " avis)";
            } else {
                document.getElementById("detailRating").textContent = "Aucun avis";
            }

            const ctWrap = document.getElementById("detailCustomTitleWrap");
            if (s.custom_title) {
                document.getElementById("detailCustomTitle").textContent = s.custom_title;
                ctWrap.style.display = "block";
            } else {
                ctWrap.style.display = "none";
            }

            const expWrap = document.getElementById("detailExperienceWrap");
            if (s.experience_years > 0) {
                document.getElementById("detailExperience").textContent = s.experience_years + " an(s)";
                expWrap.style.display = "block";
            } else {
                expWrap.style.display = "none";
            }

            document.getElementById("detailCompany").textContent = p.company_name;
            const fullName = (p.prenom + " " + p.nom).trim();
            document.getElementById("detailProviderName").textContent = fullName;

            const descWrap = document.getElementById("detailProviderDescWrap");
            if (p.description) {
                document.getElementById("detailProviderDesc").textContent = p.description;
                descWrap.style.display = "block";
            } else {
                descWrap.style.display = "none";
            }

            const reviewsEl = document.getElementById("detailReviewsList");
            if (!data.reviews || data.reviews.length === 0) {
                reviewsEl.innerHTML = '<div class="text-secondary small">Aucun avis pour le moment.</div>';
            } else {
                reviewsEl.innerHTML = data.reviews.map(r => {
                    const stars = "★".repeat(r.rating) + "☆".repeat(5 - r.rating);
                    const date = r.created_at ? new Date(r.created_at).toLocaleDateString("fr-FR") : "";
                    const comment = r.comment ? `<div class="small mt-1">${escapeHtml(r.comment)}</div>` : "";
                    return `<div class="border-bottom py-2">
                        <div class="d-flex justify-content-between">
                            <strong>${escapeHtml(r.author)}</strong>
                            <span class="text-warning">${stars}</span>
                        </div>
                        <div class="text-secondary small">${date}</div>
                        ${comment}
                    </div>`;
                }).join("");
            }

            pendingReserve = {
                serviceTypeId: serviceTypeId,
                providerId: providerId,
                companyName: p.company_name,
                serviceName: s.name
            };

            document.getElementById("detailLoading").style.display = "none";
            document.getElementById("detailContent").style.display = "block";
        } catch (e) {
            document.getElementById("detailLoading").style.display = "none";
            const errEl = document.getElementById("detailError");
            errEl.textContent = "Erreur réseau";
            errEl.style.display = "block";
        }
    }

    function escapeHtml(str) {
        const div = document.createElement("div");
        div.textContent = str;
        return div.innerHTML;
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
            select.innerHTML = '<option value="">Choisir une date d\'abord…</option>';
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
            hint.textContent = "Essaye une autre date (ou le prestataire n'a pas mis d'horaires).";
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

        document.getElementById("detailReserveBtn").addEventListener("click", function() {
            if (!pendingReserve) return;
            if (detailModalInstance) detailModalInstance.hide();
            openReserveModal(pendingReserve.serviceTypeId, pendingReserve.providerId, pendingReserve.companyName, pendingReserve.serviceName);
            const reserveEl = document.getElementById("reserveServiceModal");
            if (!reserveModalInstance) reserveModalInstance = new bootstrap.Modal(reserveEl);
            reserveModalInstance.show();
        });
    });
</script>
<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>