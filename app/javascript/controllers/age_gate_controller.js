import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "canopy_age_verified"
const EXPIRY_DAYS = 30

export default class extends Controller {
  connect() {
    const stored = localStorage.getItem(STORAGE_KEY)
    if (stored) {
      try {
        const { verified, expiry } = JSON.parse(stored)
        if (verified && Date.now() < expiry) {
          this.element.remove()
          return
        }
      } catch (_) {}
    }
    // Show modal with fade-in
    this.element.classList.remove("opacity-0")
    document.body.style.overflow = "hidden"
  }

  verify() {
    const expiry = Date.now() + EXPIRY_DAYS * 24 * 60 * 60 * 1000
    localStorage.setItem(STORAGE_KEY, JSON.stringify({ verified: true, expiry }))
    this.element.style.transition = "opacity 200ms ease-out"
    this.element.style.opacity = "0"
    setTimeout(() => {
      this.element.remove()
      document.body.style.overflow = ""
    }, 220)
  }

  deny() {
    // Redirect to a safe page or show message
    window.location.href = "https://www.google.com"
  }
}
