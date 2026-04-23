# CLAUDE.md — Worktree: Editor Sortable + Preview Fix

## Your Job
Two things only:
1. Fix preview.html.erb to use ActiveRecord block system
2. Wire Sortable.js for drag-to-reorder in the preview canvas

## Context
Worktree 1 migrated blocks from JSON blob to ActiveRecord.
preview.html.erb was NOT updated and still uses the old system.
block_selector_controller.js already has Sortable imported.

Blocks are now:
- ActiveRecord records with id (integer), block_type (string), position (integer), content (json)
- Ordered by position via acts_as_list
- Routes: DELETE /admin/blocks/:id, PATCH /admin/blocks/:id/reorder

## Scope — Touch ONLY these files
- app/views/admin/settings/preview.html.erb
- app/javascript/controllers/block_selector_controller.js

## DO NOT TOUCH
- app/views/admin/settings/edit.html.erb
- Any block partials in app/views/blocks/_*.html.erb
- Any controller
- Any model
- config/routes.rb
- CLAUDE.md itself

## preview.html.erb — Done When
- @shop.blocks loaded as AR: @shop.blocks.order(:position)
- Each block-wrapper has data-block-id="<%= block.id %>" (integer ID not hash key)
- render uses block.block_type not block['type']
- deleteBlock fetches DELETE /admin/blocks/:id using block.id
- moveBlockUp/Down replaced with Sortable drag — no index-based logic anywhere
- notifyParentOfHeight() and MutationObserver kept exactly as-is

## block_selector_controller.js — Done When
- No changes needed — Sortable initializes inside preview.html.erb only

## CRITICAL — Iframe Constraint
Sortable cannot reach inside the iframe from the parent.
Sortable must be initialized INSIDE preview.html.erb via a plain script tag.
Import Sortable via CDN script tag inside preview.html.erb.
Do NOT try to initialize Sortable from block_selector_controller.js across the iframe boundary.

## Output Standard
After every file:
CHANGES MADE:
- [file]: [what and why]

THINGS I DIDN'T TOUCH:
- [file]: [why]

POTENTIAL CONCERNS:
- [anything to verify]

## When Done
Run: rails test && rails routes | grep blocks
Show failures before fixing anything.
