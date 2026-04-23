import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { key: String }

  connect() {
    const dismissed = sessionStorage.getItem(this.keyValue || "ribbon_dismissed")
    if (dismissed) {
      this.element.remove()
    }
  }

  dismiss() {
    sessionStorage.setItem(this.keyValue || "ribbon_dismissed", "1")
    this.element.style.transition = "max-height 200ms ease-out, opacity 200ms ease-out"
    this.element.style.opacity = "0"
    this.element.style.maxHeight = "0"
    setTimeout(() => this.element.remove(), 220)
  }
}
