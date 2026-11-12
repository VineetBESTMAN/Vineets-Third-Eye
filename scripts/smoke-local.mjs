import assert from 'node:assert/strict';
import { mkdir, writeFile } from 'node:fs/promises';
import puppeteer from 'puppeteer';

const url = process.argv[2] || 'http://localhost:4173';
const output = 'qa-artifacts/local-smoke';
await mkdir(output, { recursive: true });
const browser = await puppeteer.launch({
  headless: true,
  args: ['--use-gl=angle', '--use-angle=swiftshader', '--enable-unsafe-swiftshader'],
});
const errors = [];
try {
  const page = await browser.newPage();
  await page.setViewport({ width: 1440, height: 900 });
  page.on('pageerror', (error) => errors.push(error.message));
  const response = await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 120000 });
  assert.equal(response.status(), 200);
  await page.waitForFunction(() => window.__godsEyeView?.viewer?.scene?.globe, { timeout: 120000 });
  const explore = await page.$('#first-run-launcher');
  if (explore) {
    await page.evaluate(() => {
      const buttons = [...document.querySelectorAll('#first-run-launcher button')];
      buttons.find((button) => /Explore Manually/i.test(button.textContent))?.click();
    });
  }
  await page.waitForFunction(() => {
    const viewer = window.__godsEyeView?.viewer;
    return viewer?.canvas.width > 0 && viewer?.scene.globe.tilesLoaded;
  }, { timeout: 120000 });
  const result = await page.evaluate(() => {
    const viewer = window.__godsEyeView.viewer;
    return {
      title: document.title,
      canvas: { width: viewer.canvas.width, height: viewer.canvas.height },
      globeTilesLoaded: viewer.scene.globe.tilesLoaded,
      imageryLayers: viewer.imageryLayers.length,
      sceneMode: viewer.scene.mode,
    };
  });
  await page.screenshot({ path: `${output}/globe.png` });
  await writeFile(`${output}/report.json`, JSON.stringify({ url, ...result, errors }, null, 2));
  assert.deepEqual(errors, [], 'No uncaught browser errors during keyless startup');
  console.log(JSON.stringify(result, null, 2));
} finally {
  await browser.close();
}
