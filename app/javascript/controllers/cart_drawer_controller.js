import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "overlay"]

  open() {
    this.element.classList.remove("hidden")
    document.body.style.overflow = "hidden"
    requestAnimationFrame(() => {
      this.panelTarget.classList.remove("translate-x-full")
      this.panelTarget.classList.add("translate-x-0")
      if (this.hasOverlayTarget) {
        this.overlayTarget.classList.remove("opacity-0")
        this.overlayTarget.classList.add("opacity-100")
      }
    })
  }

  close() {
    this.panelTarget.classList.add("translate-x-full")
    this.panelTarget.classList.remove("translate-x-0")
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.add("opacity-0")
      this.overlayTarget.classList.remove("opacity-100")
    }
    setTimeout(() => {
      this.element.classList.add("hidden")
      document.body.style.overflow = ""
    }, 300)
  }

  updateQuantity(event) {
    const input = event.currentTarget.closest("[data-line-item]")?.querySelector("input[data-quantity]")
    if (!input) return
    const delta = parseInt(event.currentTarget.dataset.delta || "0")
    const current = parseInt(input.value) || 1
    const next = Math.max(1, current + delta)
    input.value = next
  }
}
