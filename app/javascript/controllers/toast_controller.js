import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  show({ detail: { message, type = "info", action = null, actionUrl = null } }) {
    const toast = document.createElement("div")
    toast.className = [
      "pointer-events-auto flex items-start gap-3 bg-white border border-[#E8E8E3]",
      "rounded-lg px-4 py-3 shadow-elevated min-w-[280px] max-w-[360px]",
      "transition-all duration-200 ease-out opacity-0 translate-y-2"
    ].join(" ")

    const iconColor = type === "success" ? "#6B8E5A" : type === "error" ? "#C94F4F" : "#8A8A85"
    const icon = type === "success"
      ? `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="${iconColor}" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>`
      : type === "error"
        ? `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="${iconColor}" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>`
        : `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="${iconColor}" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>`

    toast.innerHTML = `
      <span class="mt-0.5 shrink-0">${icon}</span>
      <span class="text-small text-[#1A1A17] flex-1">${message}${action ? ` <a href="${actionUrl}" class="underline font-medium">${action}</a>` : ""}</span>
      <button onclick="this.parentElement.remove()" class="text-[#8A8A85] hover:text-[#1A1A17] transition-colors shrink-0">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
      </button>
    `

    this.element.appendChild(toast)
    requestAnimationFrame(() => {
      toast.classList.remove("opacity-0", "translate-y-2")
    })

    setTimeout(() => {
      toast.classList.add("opacity-0", "translate-y-2")
      setTimeout(() => toast.remove(), 220)
    }, 4000)
  }
}
