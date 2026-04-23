import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["main", "thumbnail", "overlay", "overlayImg"]

  selectThumb(event) {
    const src = event.currentTarget.dataset.src
    const alt = event.currentTarget.dataset.alt || ""
    if (!src || !this.hasMainTarget) return

    this.mainTarget.src = src
    this.mainTarget.alt = alt

    this.thumbnailTargets.forEach(t => {
      t.classList.toggle("ring-2", t === event.currentTarget)
      t.classList.toggle("ring-[#1A1A17]", t === event.currentTarget)
      t.classList.toggle("opacity-50", t !== event.currentTarget)
    })
  }

  openLightbox() {
    if (!this.hasOverlayTarget || !this.hasMainTarget) return
    this.overlayImgTarget.src = this.mainTarget.src
    this.overlayImgTarget.alt = this.mainTarget.alt
    this.overlayTarget.classList.remove("hidden", "opacity-0")
    this.overlayTarget.classList.add("opacity-100")
    document.body.style.overflow = "hidden"
  }

  closeLightbox() {
    if (!this.hasOverlayTarget) return
    this.overlayTarget.classList.add("opacity-0")
    setTimeout(() => {
      this.overlayTarget.classList.add("hidden")
      document.body.style.overflow = ""
    }, 200)
  }
}
