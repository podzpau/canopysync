import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "content", "icon"]

  toggle(event) {
    const item = event.currentTarget.closest("[data-accordion-item]")
    if (!item) return
    const content = item.querySelector("[data-accordion-target='content']")
    const icon = item.querySelector("[data-accordion-target='icon']")
    const isOpen = !content.classList.contains("hidden")

    // Close all
    this.element.querySelectorAll("[data-accordion-item]").forEach(i => {
      const c = i.querySelector("[data-accordion-target='content']")
      const ic = i.querySelector("[data-accordion-target='icon']")
      if (c) {
        c.classList.add("hidden")
        i.classList.remove("bg-[#F5F5F1]")
      }
      if (ic) ic.style.transform = "rotate(0deg)"
    })

    // Open clicked (if it was closed)
    if (!isOpen && content) {
      content.classList.remove("hidden")
      item.classList.add("bg-[#F5F5F1]")
      if (icon) icon.style.transform = "rotate(180deg)"
    }
  }
}
