function getUser(){
  try { return JSON.parse(localStorage.getItem("sh_user") || "{}"); }
  catch { return {}; }
}

function fillUserPlaceholders(){
  const u = getUser();
  document.querySelectorAll("[data-user-name]").forEach(el => el.textContent = u.name || "Adhérent·e");
  document.querySelectorAll("[data-user-email]").forEach(el => el.textContent = u.email || "—");
}

document.addEventListener("DOMContentLoaded", fillUserPlaceholders);