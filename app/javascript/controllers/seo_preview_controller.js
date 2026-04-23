import { Controller } from "@hotwired/stimulus"

// Live SERP preview + focus keyword checks.
// Targets: titleInput, descInput, keywordInput, urlDisplay
//          previewTitle, previewUrl, previewDesc
//          kwInTitle, kwInDesc, kwInUrl
export default class extends Controller {
  static targets = [
    "titleInput", "descInput", "keywordInput", "urlDisplay",
    "previewTitle", "previewUrl", "previewDesc",
    "kwInTitle", "kwInDesc", "kwInUrl"
  ]
  static values = { autoTitle: String, autoDesc: String, canonicalUrl: String }

  connect() {
    this.update()
  }

  update() {
    const title   = this.titleInputTarget.value.trim() || this.autoTitleValue
    const desc    = this.descInputTarget.value.trim()  || this.autoDescValue
    const keyword = this.keywordInputTarget.value.trim().toLowerCase()
    const url     = this.hasUrlDisplayTarget ? this.urlDisplayTarget.textContent : this.canonicalUrlValue

    this.previewTitleTarget.textContent = title
    this.previewUrlTarget.textContent   = url
    this.previewDescTarget.textContent  = desc

    if (keyword) {
      this.setKw(this.kwInTitleTarget, title.toLowerCase().includes(keyword))
      this.setKw(this.kwInDescTarget,  desc.toLowerCase().includes(keyword))
      this.setKw(this.kwInUrlTarget,   url.toLowerCase().includes(keyword))
    } else {
      [this.kwInTitleTarget, this.kwInDescTarget, this.kwInUrlTarget].forEach(el => {
        el.textContent = "—"
        el.className = "text-gray-400 text-sm"
      })
    }
  }

  setKw(el, pass) {
    if (pass) {
      el.textContent = "✓ Yes"
      el.className = "text-emerald-600 font-medium text-sm"
    } else {
      el.textContent = "✗ No"
      el.className = "text-red-500 font-medium text-sm"
    }
  }
}
