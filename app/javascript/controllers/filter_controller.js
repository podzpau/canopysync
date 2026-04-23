import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "mobilePanel", "mobileOverlay", "activeFilters"]

  connect() {
    this._syncActiveFilters()
  }

  submit() {
    if (this.hasFormTarget) {
      this.formTarget.requestSubmit()
    }
  }

  openMobile() {
    if (!this.hasMobilePanelTarget) return
    this.mobilePanelTarget.classList.remove("hidden")
    document.body.style.overflow = "hidden"
    requestAnimationFrame(() => {
      this.mobilePanelTarget.classList.remove("translate-y-full")
    })
  }

  closeMobile() {
    if (!this.hasMobilePanelTarget) return
    this.mobilePanelTarget.classList.add("translate-y-full")
    setTimeout(() => {
      this.mobilePanelTarget.classList.add("hidden")
      document.body.style.overflow = ""
    }, 300)
  }

  clearAll() {
    if (!this.hasFormTarget) return
    this.formTarget.querySelectorAll("input[type=checkbox]").forEach(cb => cb.checked = false)
    this.formTarget.querySelectorAll("input[type=range]").forEach(r => r.value = r.defaultValue)
    this.formTarget.querySelectorAll("input[type=text], input[type=search]").forEach(i => {
      if (i.dataset.filterSearch !== undefined) i.value = ""
    })
    this.formTarget.requestSubmit()
  }

  removeFilter(event) {
    const { name, value } = event.currentTarget.dataset
    if (!name || !this.hasFormTarget) return
    const input = this.formTarget.querySelector(`input[name="${name}"][value="${value}"]`)
    if (input) { input.checked = false; this.formTarget.requestSubmit() }
  }

  _syncActiveFilters() {
    if (!this.hasFormTarget || !this.hasActiveFiltersTarget) return
    const checked = [...this.formTarget.querySelectorAll("input[type=checkbox]:checked")]
    this.activeFiltersTarget.innerHTML = checked.map(cb => `
      <button data-action="click->filter#removeFilter" data-name="${cb.name}" data-value="${cb.value}"
        class="inline-flex items-center gap-1 text-small bg-[#F5F5F1] border border-[#E8E8E3] rounded-full px-3 py-1 hover:bg-[#E8E8E3] transition-colors">
        ${cb.dataset.label || cb.value}
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
      </button>
    `).join("")
  }
}
