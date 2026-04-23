import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bar", "mobileMenu", "mobileOverlay"]

  connect() {
    this._onScroll = this._onScroll.bind(this)
    window.addEventListener("scroll", this._onScroll, { passive: true })
    this._onScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this._onScroll)
    document.body.style.overflow = ""
  }

  _onScroll() {
    if (!this.hasBarTarget) return
    if (window.scrollY > 4) {
      this.barTarget.classList.add("nav-scrolled")
    } else {
      this.barTarget.classList.remove("nav-scrolled")
    }
  }

  openMobile() {
    if (!this.hasMobileMenuTarget) return
    this.mobileMenuTarget.classList.remove("hidden", "opacity-0")
    this.mobileMenuTarget.classList.add("opacity-100")
    document.body.style.overflow = "hidden"
  }

  closeMobile() {
    if (!this.hasMobileMenuTarget) return
    this.mobileMenuTarget.classList.add("opacity-0")
    setTimeout(() => {
      this.mobileMenuTarget.classList.add("hidden")
      document.body.style.overflow = ""
    }, 200)
  }

  toggleLocation(event) {
    const dropdown = event.currentTarget.nextElementSibling
    if (!dropdown) return
    dropdown.classList.toggle("hidden")
  }
}
