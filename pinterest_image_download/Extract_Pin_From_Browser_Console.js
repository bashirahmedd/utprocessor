// Type this exactly into the Console and press Enter:
// allow pasting
// Then paste the snippet I gave you and press Enter.

// write js script select for the following a element to extract href from the whole page

// Take the following a tag from the current pinterest page loaded with visual search
//<a aria-label="Interactive worksheets maker for all pin page" class="etmDmh i7jpet zlD4hU Q3hcOU dHA5K0 O0u6sV KQwCbH be_g_n ap8aAM" href="/pin/605734218631177885/" rel="" tabindex="0"><div data-test-id="pin-missing-alt-text" class="ADXRXN MJ_eMy XC5OnJ gHrR3r"><div class="PinCard__imageWrapper" data-test-image-signature="f38818a2206b213077da6ff885aae99b" style="position: relative;"><div data-test-id="pincard-image-with-link" class="ADXRXN WTrvgR gEQpi5 gcIrSY" style="clip-path: inset(0 round var(--sema-rounding-400)); will-change: transform; text-decoration: none;"><div class="e2jAjp DodKMr N9tO7e"><div data-test-id="pinrep-image" class="ADXRXN" style="margin-top: 0%; margin-bottom: 0%; aspect-ratio: var(--story-item-width-height-ratio, auto); min-height: 55px;"><div class="ADXRXN"><div data-test-id="non-story-pin-image" class="ADXRXN" style="height: 100%; width: 100%;"><div class="ADXRXN" style="height: inherit; width: inherit;"><div class="ADXRXN gEQpi5" style="background-color: rgb(251, 251, 245); padding-bottom: 144.068%;"><img alt="This may contain: the worksheet shows how to make an interactive math game for children and adults" class="iFOUS5" draggable="true" fetchpriority="auto" loading="auto" elementtiming="grid-non-story-pin-image-unknown" srcset="https://i.pinimg.com/236x/f3/88/18/f38818a2206b213077da6ff885aae99b.jpg 1x, https://i.pinimg.com/474x/f3/88/18/f38818a2206b213077da6ff885aae99b.jpg 2x, https://i.pinimg.com/736x/f3/88/18/f38818a2206b213077da6ff885aae99b.jpg 3x, https://i.pinimg.com/originals/f3/88/18/f38818a2206b213077da6ff885aae99b.jpg 4x" src="https://i.pinimg.com/236x/f3/88/18/f38818a2206b213077da6ff885aae99b.jpg"></div></div></div></div></div><div class="SXrTgC"></div></div></div></div></div></a>


//The following snippet will show the pin for the loaded pin elements in the page, re-build snippet with chatgpt if not working 
const pinLinks = [...document.querySelectorAll('a[href^="/pin/"]')]
  .map(a => new URL(a.getAttribute("href"), location.href).href);

console.log(pinLinks);
copy(pinLinks);