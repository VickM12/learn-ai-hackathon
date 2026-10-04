export type Varietal = {
  name: string;
  aliases: string[];
  species: string;
  color: string;
  hardiness: string;
  summary: string;
  planting: string;
  maintenance: string;
  harvesting: string;
};

const varietals: Varietal[] = [
  {
    name: "Concord",
    aliases: [],
    species: "Vitis labrusca",
    color: "Blue-black",
    hardiness: "Reliable here",
    summary: "The standard northeastern labrusca. Slip-skin, strongly aromatic, and dependable for juice, jelly, and sweet wine on an exposed northeast Ohio site.",
    planting: "Plant dormant bare-root vines in spring, after the soil can be worked and before buds swell. Own-rooted Concord handles this climate; grafting is unnecessary. Give each vine full sun and about 8 feet in the row. Soil pH around 5.5–6.5 is comfortable. Drainage matters more than richness. Train it to a high wire, about 5–6 feet, because the shoots trail.",
    maintenance: "Prune in late winter while the vine is dormant. A mature Concord often carries roughly 40–60 buds, depending on how thick last year’s wood was. Through summer, comb the canopy downward so air reaches the clusters. In humid Ohio weather, watch black rot, downy mildew, and phomopsis, plus Japanese beetles and grape berry moth. Do not let a young vine ripen a crop in its first two years.",
    harvesting: "Berries are ready when they are blue-black, the seeds are brown, and a berry slips free of the pulp with a gentle tug. Growers often pick around 16–18 °Brix, commonly from mid-September into early October here. Concord gets sweeter and more aromatic if it hangs, and it also attracts birds. Pick into the shade.",
  },
  {
    name: "Niagara",
    aliases: [],
    species: "Vitis labrusca",
    color: "White",
    hardiness: "Reliable here",
    summary: "A white labrusca with the same foxiness as Concord, widely grown for juice and fresh eating. Culture is almost the same, and it ripens a little earlier.",
    planting: "Use the same spring bare-root planting and own roots as Concord. Space vines about 8 feet apart on a high wire. A soil pH of 5.5–6.5 suits it. Niagara is vigorous. Keep it out of a frost pocket if you have a better slope, because the first shoots can still be nipped.",
    maintenance: "Dormant-prune to a high cordon. The canopy gets dense, so pull a few leaves around clusters after fruit set if the interior stays wet after rain. Disease pressure matches Concord: black rot and downy mildew in a wet June, beetles in July. Thin the crop on a young or weak vine.",
    harvesting: "Pick when berries are green-gold and the skin slips. Niagara is often ready just before Concord, frequently early to mid-September here. Sugar is commonly in the mid-teens °Brix. The flavor gets heavier if you wait. For fresher juice, pick once the slip-skin stage is even across the cluster.",
  },
  {
    name: "Catawba",
    aliases: [],
    species: "Vitis labrusca",
    color: "Pink",
    hardiness: "Reliable here",
    summary: "A pink labrusca with a long Ohio history. It needs more season than Concord and finishes with higher acid, which is why it became a sparkling and sweet-wine grape.",
    planting: "Plant own-rooted vines in spring on the warmest well-drained spot you have. Use a high wire and about 8 feet between vines. Soil pH around 5.5–6.5 is fine. A shaded or north-facing spot will leave this late grape short of ripe.",
    maintenance: "Prune in dormancy to a high cordon, and do not overcrop. A heavy crop pushes harvest even later. The disease list is the labrusca set: black rot, downy mildew, phomopsis, and berry moth. Winter hardiness is not the problem in this region. Give the canopy room so late clusters can dry.",
    harvesting: "Color goes dull pink to copper, and the slip-skin stage arrives later than Concord, often late September or October. Acid stays noticeable. Taste and check the seeds rather than picking on color alone. Fruit caught by an early frost is still usable, but it will be sharper.",
  },
  {
    name: "Marquette",
    aliases: [],
    species: "Cold-hardy hybrid",
    color: "Red",
    hardiness: "Reliable here",
    summary: "A University of Minnesota red bred for Upper Midwest winters and dry red wine. The wood is very cold hardy. Buds push early, so spring frost is the risk, not January.",
    planting: "Plant own-rooted bare-root vines in spring. Full sun, soil pH about 6.0–6.5, and 6–8 feet in the row. A high single curtain is the usual training for a small vineyard. Avoid a low frost pocket.",
    maintenance: "Spur-prune in late winter on the high cordon. Marquette is vigorous and fruitful, so thin clusters by fruit set on a young vine or when you want riper flavor. Downy mildew deserves more attention than it does on Frontenac. Open the fruit zone after set. Take no crop the first two years. Trunk burial is normally unnecessary here.",
    harvesting: "Often ripe from late August through mid-September, ahead of Frontenac. Sugar can reach the mid-20s °Brix while acid is still high. Taste for when the green edge drops. Many small plantings pick near 24 °Brix rather than chasing the last point of sugar. Birds find it as soon as the color turns.",
  },
  {
    name: "Frontenac",
    aliases: [],
    species: "Cold-hardy hybrid",
    color: "Red",
    hardiness: "Reliable here",
    summary: "The workhorse cold-hardy red. It ripens in a short season, survives a hard winter, and still carries high acid at harvest. It suits a richer or off-dry red better than a soft one.",
    planting: "Own roots, spring planting, high wire, 6–8 feet apart, soil pH about 6.0–6.5. Frontenac is very vigorous, so give it air and do not crowd it against a wall. A reasonably drained site in northeast Ohio is winter-safe.",
    maintenance: "Spur-prune, and remove extra shoots. Canopy control is the main job, not winter protection. Disease tolerance is good for a humid climate, but black rot can still mark fruit in a wet spring. Crop thinning helps flavor. Keep the trunk clear of suckers.",
    harvesting: "Dark color arrives before the flavor does. Sugar climbs readily into the mid-20s °Brix, often in late September, while acid stays high. Some growers wait for a light frost to soften the acid. Seeds should be brown and the cluster stem woody. Hang it only as long as rot and birds allow.",
  },
  {
    name: "Frontenac Gris",
    aliases: ["Frontenac Gray"],
    species: "Cold-hardy hybrid",
    color: "Pink",
    hardiness: "Reliable here",
    summary: "A bronze-pink sport of Frontenac. Same vine, different fruit color, used for white or copper-tinged wines. Acid and vigor match the parent.",
    planting: "Plant it the same way as Frontenac: own-rooted, high wire, 6–8 feet, spring, soil pH near 6.0–6.5. Site choice is the same.",
    maintenance: "Use the same dormant spur pruning, and keep a vigorous canopy open. The disease profile follows Frontenac. Pink berries can look ripe early. Do not let color decide the canopy work.",
    harvesting: "Pick on sugar, seed color, and taste, not on the gray-pink hue. Timing is close to Frontenac, often late September. Earlier picks stay bright. Later picks are rounder and still acidic. Wasps and birds respond once the fruit softens.",
  },
  {
    name: "Frontenac Blanc",
    aliases: [],
    species: "Cold-hardy hybrid",
    color: "White",
    hardiness: "Reliable here",
    summary: "A white selection from Frontenac Gris. It keeps the winter hardiness and the high acid, with green-gold fruit.",
    planting: "Use the Frontenac planting plan. Own roots and a high cordon suit a small Ohio row. Soil pH about 6.0–6.5.",
    maintenance: "It is vigorous. Spur-prune, thin shoots, and watch black rot early in the season. No special winter protection is needed in this region.",
    harvesting: "It finishes later than La Crescent and often with Frontenac, from late September into October. Sugar accumulates easily and acid lingers. For a fresher white, pick before the fruit tastes overripe. For more body, let it hang and plan on the acid.",
  },
  {
    name: "La Crescent",
    aliases: [],
    species: "Cold-hardy hybrid",
    color: "White",
    hardiness: "Reliable here",
    summary: "A cold-hardy white with apricot and floral flavor and high acid. It ripens earlier than Frontenac and is less forgiving of wet leaves.",
    planting: "Own-rooted, spring, high wire, 6–8 feet, soil pH 6.0–6.5. Give it the breeziest part of the row. Winter hardiness is not the limiting factor here.",
    maintenance: "Spur-prune to a high cordon. Downy mildew and black rot need a tighter spray rhythm than on Frontenac, especially from pre-bloom through bunch closure. Thin clusters if the vine sets heavily. Open the fruit zone so mornings can dry the berries.",
    harvesting: "Often ready in early to mid-September. Sugar in the low-to-mid 20s °Brix is common, with acid still high. Pick when the floral flavor is present and the berries are softening, before rot starts in a rainy spell. It does not benefit from hanging as long as Frontenac.",
  },
  {
    name: "Itasca",
    aliases: [],
    species: "Cold-hardy hybrid",
    color: "White",
    hardiness: "Reliable here",
    summary: "A Minnesota white meant to ripen with less acid than La Crescent, for dry table wine. Cold hardy and mid-season. A better fit than vinifera if you want a dry white from this site.",
    planting: "Own roots, spring, full sun, soil pH about 6.0–6.5, 6–8 feet, high wire. Choose a spot with air movement. It does not need to be buried for a normal northeast Ohio winter.",
    maintenance: "Spur-prune and keep the crop moderate while the vine is young. Disease tolerance is decent for the region, but still cover the early black-rot window. Shoot-thin so mid-season fruit sees sun. Remove fruit in years one and two.",
    harvesting: "Typically mid-September in the North. Taste is the guide: developed flavor, without the sharp acid of an early pick or the flatness of an overripe one. Sugar often lands in the low-to-mid 20s °Brix. Birds will sample it once it softens.",
  },
  {
    name: "Petite Pearl",
    aliases: ["Petite Perle"],
    species: "Cold-hardy hybrid",
    color: "Red",
    hardiness: "Reliable here",
    summary: "A northern red with later bud break than Marquette, which helps it dodge spring frost. Acid is gentler than Frontenac, and the clusters are small.",
    planting: "Own-rooted, spring, 6–8 feet, high cordon, soil pH 6.0–6.5. A slightly frost-prone spot is more acceptable than it would be for Marquette, because buds push later. Drainage still matters.",
    maintenance: "Vigor is moderate, so do not prune it as hard as Frontenac or you will undercrop it. Spur-prune to the cordon and leave a bud count that matches the wood. Black rot in a wet May is the disease to respect. Net the small dark berries or the birds will.",
    harvesting: "Mid to late September in a normal season. Pick when seeds are brown and the berry flavor has lost its green edge. Sugar is often around the low 20s °Brix. It does not need a frost to be usable.",
  },
  {
    name: "Edelweiss",
    aliases: [],
    species: "Cold-hardy hybrid",
    color: "White",
    hardiness: "Reliable here",
    summary: "An early Swenson white, hardy and productive, with a labrusca-like aroma that gets stronger the longer it hangs. Often used for off-dry wine or fresh eating.",
    planting: "Own roots, spring, high wire, 7–8 feet, soil pH 5.5–6.5. Buds break early, so a frost pocket will cost you the first shoots. Give it full sun.",
    maintenance: "It sets a heavy crop. Thin clusters or the flavor stays thin. Dormant-prune to the cordon, and do not try to ripen every bunch on a young plant. Early fruit needs netting sooner than the red hybrids. Black rot can mark the early clusters.",
    harvesting: "One of the first to finish, often mid to late August here. Pick while acid is still lively if you want a cleaner flavor. Left into September it becomes very aromatic and lower in acid. A full golden color and slipping skin are the visual cues. Wasps find it early.",
  },
  {
    name: "Brianna",
    aliases: [],
    species: "Cold-hardy hybrid",
    color: "White",
    hardiness: "Reliable here",
    summary: "An early Swenson white with fruity flavor and lower acid than the Minnesota hybrids. Easy to overripen.",
    planting: "Own-rooted, spring, high wire, 6–8 feet, soil pH 6.0–6.5. Because it ripens early, a warmer site is optional. Winter survival is the easy part.",
    maintenance: "Watch black rot and downy mildew. Early sugar means birds, bees, and wasps. Net as soon as the berries soften, which can be August. Prune in dormancy and thin a heavy set. A typical winter here does not require trunk protection.",
    harvesting: "Pick earlier than you would Frontenac. Once Brianna tastes ripe, acid falls quickly and a hot week can leave it flat. Many northern growers pick in late August or early September. Taste every few days once the berries soften.",
  },
  {
    name: "St. Croix",
    aliases: ["Saint Croix", "St Croix"],
    species: "Cold-hardy hybrid",
    color: "Red",
    hardiness: "Reliable here",
    summary: "A Swenson red that ripens with moderate acid and can drink more like a table red than Frontenac does. Hardy, productive, and prone to uneven ripeness inside the cluster.",
    planting: "Own roots, spring, high cordon, 6–8 feet, soil pH 6.0–6.5. Give the canopy sun. Shaded fruit on this variety lags behind the exposed berries.",
    maintenance: "Spur-prune, and pull leaves on the morning side of the fruit zone so clusters ripen together. It can overcrop. Disease pressure is typical for a humid summer. Winter hardiness is sufficient here without burying canes.",
    harvesting: "Early to mid-September is common. Taste berries from the inside of the cluster, not just the shoulder. St. Croix can show color before the center berries are ready. Sugar often settles in the low 20s °Brix. Do not wait for a frost.",
  },
  {
    name: "Marechal Foch",
    aliases: ["Foch", "Marshal Foch"],
    species: "French-American hybrid",
    color: "Red",
    hardiness: "Reliable here",
    summary: "An early red hybrid with small berries. Useful when you want color and sugar before the fall rains. It will overcrop if you let it.",
    planting: "Own roots, spring, high wire, 6–8 feet, soil pH 6.0–6.5. Buds break early, so avoid a frost pocket. Winter protection is generally unnecessary here.",
    maintenance: "Too much fruit is the classic problem. Thin hard after set, especially on young vines. Spur-prune. Small berries color early and then sit. Disease pressure is moderate. Net early.",
    harvesting: "Often mid-August to early September in northeast Ohio. Sugar can reach the low 20s °Brix while acid drops. Pick when the green flavor is gone and before the berries shrivel. Taste several berries per cluster, because ripeness is often uneven.",
  },
  {
    name: "Cayuga White",
    aliases: ["Cayuga"],
    species: "French-American hybrid",
    color: "White",
    hardiness: "Usually hardy",
    summary: "A Cornell hybrid and a practical white for this climate: productive, reasonably hardy, and fairly neutral. A vine you can ripen without fighting a vinifera winter.",
    planting: "Own-rooted in most small plantings. Spring, high or mid wire, 6–8 feet, soil pH 6.0–6.5. On an exposed hilltop in the coldest part of northeast Ohio, mound soil over the crown in late fall for the first few winters until you see how the trunks take it.",
    maintenance: "It will overcrop. Cluster-thin after set if you want flavor instead of a large watery yield. Spur-prune or short-cane prune. Disease resistance is better than vinifera, not immunity. Keep the early black-rot sprays, and open the canopy in July.",
    harvesting: "Early to mid-September on many eastern sites. Pick when flavor fills in, often around 18–21 °Brix, before the crop tastes dilute. Acid is manageable compared with La Crescent. A rainy delay invites botrytis in the tighter parts of the cluster.",
  },
  {
    name: "Seyval Blanc",
    aliases: ["Seyval"],
    species: "French-American hybrid",
    color: "White",
    hardiness: "Usually hardy",
    summary: "A productive, early white hybrid with neutral flavor and a habit of carrying too much fruit. Moderately hardy for this region.",
    planting: "Own-rooted, spring, high or mid wire, 6–8 feet, soil pH 6.0–6.5. An ordinary well-drained vineyard site is enough. Hilling the crown helps on the coldest, windiest spots.",
    maintenance: "Cluster-thin. Seyval will set more than it can ripen into anything with flavor. Spur-prune to the cordon, then remove surplus bunches after set. Disease susceptibility is average. Keep the canopy combed or tucked so the fruit dries.",
    harvesting: "Early to mid-September. Pick around 18–21 °Brix once the taste is no longer grassy. Leaving an overcropped vine out longer does not create flavor. Acid is usually workable for a dry or sparkling wine.",
  },
  {
    name: "Vignoles",
    aliases: ["Ravat 51"],
    species: "French-American hybrid",
    color: "White",
    hardiness: "Usually hardy",
    summary: "A tight-clustered white that can make a fine late-harvest wine and can also rot in a wet September. Moderately hardy.",
    planting: "Own roots, spring, 6–8 feet, soil pH 6.0–6.5, on a site with air movement. The clusters stay compact. A high wire works. Hill the crown on an exposed site until you know the trunks.",
    maintenance: "Botrytis is the maintenance story. Leaf-pull as soon as the fruit zone is set, and do not let foliage pack around the clusters. Thin the crop. A wet bloom can leave poor fruit set, which is not always a disaster on this variety. Early black-rot sprays still apply.",
    harvesting: "Mid to late September for a table wine, later if the fruit is clean and you want a sweeter style. Sugar climbs high. If botrytis spreads in a rain, pick the clean fruit rather than waiting for one more degree of sugar.",
  },
  {
    name: "Traminette",
    aliases: [],
    species: "French-American hybrid",
    color: "White",
    hardiness: "Usually hardy",
    summary: "A Gewürztraminer hybrid with some of that floral, spicy aroma and better cold tolerance than Gewürztraminer itself. Still not as bombproof as Frontenac.",
    planting: "Own-rooted, spring, 6–8 feet, full sun, soil pH 6.0–6.5, on a high cordon. Give it your warmer row if you have a choice, so the aroma can develop. Hill the crown where winters drop well below zero with no snow cover.",
    maintenance: "Moderate vigor, and a tendency to carry more crop than the flavor can support. Thin to one or two clusters per shoot after set. Spur-prune. Disease tolerance is reasonable. Still cover black rot and downy mildew. Leaf-pull lightly so an August heat spike does not sunburn the berries.",
    harvesting: "Mid to late September. Pick when the spicy aroma is obvious in the berry, not when sugar first looks acceptable. Growers often land around 20–22 °Brix. Overripe fruit loses the freshness that makes this variety worth growing.",
  },
  {
    name: "Vidal Blanc",
    aliases: ["Vidal"],
    species: "French-American hybrid",
    color: "White",
    hardiness: "Usually hardy",
    summary: "A white hybrid used for dry, sparkling, and late-harvest wines. Hardy enough for many northeastern vineyards, and late to ripen.",
    planting: "Own roots are common. Spring planting, 6–8 feet, high wire, soil pH 6.0–6.8. Choose a site that holds heat into October. Trunk injury is possible in a severe winter here. Hilling the crown is cheap insurance on a six-vine planting.",
    maintenance: "It is productive. Thin the crop or harvest runs late and green. Cane-prune or spur-prune depending on how you laid out the cordon. Botrytis is the late-season issue if September is wet, which is also why people let clean fruit hang for a dessert wine. Keep the fruit zone open.",
    harvesting: "Late September into October. For a dry wine, pick once sugar is near 20–22 °Brix and the flavor is no longer grassy. For a sweeter style, leave clean clusters longer and watch for rot after each rain. Frost on healthy fruit is acceptable. Rot is not.",
  },
  {
    name: "Chambourcin",
    aliases: [],
    species: "French-American hybrid",
    color: "Red",
    hardiness: "Protect the trunk",
    summary: "A red hybrid that can make a deep wine in the East. It ripens late, and northeast Ohio is near the edge of its winter hardiness.",
    planting: "Plant on the warmest, most sheltered, well-drained ground you have. Own roots are usual. Space 6–8 feet. A high wire is common in the East. Soil pH 6.0–6.5. Hill soil over the crown each fall. A winter near the cold end of this region can damage trunks.",
    maintenance: "It sets a large crop and must be thinned or it will not ripen before frost. Spur-prune, then remove clusters after set so the remaining fruit can color. It is comparatively disease tolerant, which helps in a humid September, and that is not a reason to skip the early sprays. Keep the fruit zone open late in the year.",
    harvesting: "Expect late September or October, and accept that a cool year may not finish it. Pick when color is even and seeds are brown, often around 21–23 °Brix if the season allows. Green seeds and pale shoulders mean wait, unless a hard frost is forecast.",
  },
  {
    name: "Norton",
    aliases: ["Cynthiana"],
    species: "Vitis aestivalis",
    color: "Red",
    hardiness: "Reliable here",
    summary: "An American red, also called Cynthiana, with real disease resistance and a long hang time. Winter hardy in Ohio, and it needs the whole season.",
    planting: "Plant it own-rooted. Norton does poorly on many ordinary wine rootstocks, so do not graft it. Spring, about 8 feet, high wire, soil pH 6.0–6.5. Magnesium deficiency shows up on this variety, so a soil test before planting is worth more here than it is for Concord. Give it full sun and a long, warm exposure.",
    maintenance: "Late bud break is a gift in frost country. Prune in dormancy to a high cordon, and do not overcrop a young vine. Norton can look vigorous in leaf and still ripen late. It is notably resistant to black rot, downy mildew, and powdery mildew, so the spray list is shorter, not empty. Yellowing between the veins on older leaves in midsummer often means magnesium.",
    harvesting: "This is October fruit, and usually the last red you will pick. Sugar rises slowly. High pH together with a still-sharp taste is normal for Norton and unlike the hybrids above. Pick on brown seeds, woody stems, and taste, not on a single Brix number. A rainy October is the enemy.",
  },
  {
    name: "Riesling",
    aliases: [],
    species: "Vitis vinifera",
    color: "White",
    hardiness: "Tender here",
    summary: "The vinifera white most often tried in the East. It can be excellent on a lake-moderated site, and it can die back in an open northeast Ohio winter.",
    planting: "Buy vines grafted to a phylloxera-resistant rootstock. Plant in spring, 4–6 feet apart, and plan on vertical shoot positioning rather than a high trailing curtain. Soil pH closer to 6.0–6.8. Use your warmest well-drained row, with some protection from west wind. Hill soil over the graft union every fall.",
    maintenance: "Cane pruning is common because Riesling’s fruitful buds often sit farther out the cane. Tuck shoots into the catch wires. Powdery mildew, downy mildew, and botrytis are all realistic in this humidity. A May frost can still take the shoots. Do not crop the vine until the trunk is established.",
    harvesting: "Late September or October when the year allows. Cool-climate dry Riesling is often picked around 18–21 °Brix with acid still present. Botrytis on clean fruit and botrytis in a wet year are different outcomes; sort them. If the vine winter-killed, there may be little to pick.",
  },
  {
    name: "Chardonnay",
    aliases: [],
    species: "Vitis vinifera",
    color: "White",
    hardiness: "Tender here",
    summary: "Early-budding vinifera. Possible on a favored Ohio site, unreliable on an exposed one. Frost, disease, and winter injury take more of the work than they do with Marquette or Concord.",
    planting: "Use a grafted rootstock. Plant in spring on vertical shoot positioning, 4–6 feet apart, soil pH 6.0–6.8, in the warmest protected spot. Hill the graft union. If you only have an open field, a cold-hardy white is the more honest planting.",
    maintenance: "Cane-prune or spur-prune depending on the clone and the training. Tuck shoots and leaf-pull. Powdery mildew is the signature disease, with downy mildew and botrytis behind it. Crown gall can follow winter cracks in the trunk. Renew a damaged trunk from a sucker. Crop lightly.",
    harvesting: "Often early to mid-September if it ripens. Pick on flavor and acid, commonly near 20–23 °Brix for a still wine. Do not wait through a week of rain once it is ready. The skins are not as tolerant as a hybrid’s.",
  },
  {
    name: "Gewürztraminer",
    aliases: ["Gewurztraminer"],
    species: "Vitis vinifera",
    color: "Pink",
    hardiness: "Tender here",
    summary: "Aromatic and pink-skinned, earlier than Riesling, and more tender in winter. Traminette is the related vine better suited to an average northeast Ohio site.",
    planting: "Grafted, vertical shoot positioning, 4–6 feet, a warm protected site, soil pH 6.0–6.8. Hill the graft union. This is not a high-wire own-root vine.",
    maintenance: "Moderate crops make the aroma. Heavy crops taste like nothing. Thin after set. Powdery mildew and winter injury are the two recurring jobs. Cane-prune if bud survival was poor and you need to keep the wood that lived.",
    harvesting: "Early to mid-September when the vintage allows. Pick when the lychee-spice aroma is strong in the berry, often near 21–23 °Brix, before acid collapses. Rot in the tight clusters ends the hang time.",
  },
  {
    name: "Pinot Gris",
    aliases: ["Pinot Grigio"],
    species: "Vitis vinifera",
    color: "Pink",
    hardiness: "Tender here",
    summary: "The gray-pink form of Pinot, sold as Pinot Grigio when it is picked earlier and leaner. Same tenderness and tight-cluster problems, used for white wine.",
    planting: "Use the same grafted, vertical-shoot planting as Pinot Noir. It wants a warm, airy site and a hilled graft union. It is not a substitute for La Crescent or Itasca if winter survival is the goal.",
    maintenance: "Cane-prune or spur-prune, open the fruit zone, and stay ahead of powdery mildew and botrytis. It ripens earlier than Riesling, which is the advantage, and the berries crack, which is the cost. Net it.",
    harvesting: "For a Grigio style, pick earlier while acid is bright, often late August or early September, around 19–21 °Brix. For a richer Gris style, wait for more flavor and accept the rot risk. The pink blush shows up before the berry is ready.",
  },
  {
    name: "Pinot Noir",
    aliases: [],
    species: "Vitis vinifera",
    color: "Red",
    hardiness: "Tender here",
    summary: "Early, thin-skinned, and rot-prone. Cold hardiness is only moderate. A difficult vine for humid northeast Ohio and a poor first choice on an open site.",
    planting: "Grafted, vertical shoot positioning, about 4–5 feet, and only on your best site. Soil pH 6.0–6.8. Hill the graft. If the spot is windy and wet, plant something else.",
    maintenance: "Cane pruning is common. The work is canopy and rot: leaf-pull enough for airflow, not so much that berries sunburn. Powdery mildew and botrytis dominate. Tight clusters crack after rain. Bird netting is nearly mandatory. Winter damage and crown gall recur.",
    harvesting: "Early to mid-September when it works. Pick as soon as flavor is there, often around 20–22 °Brix, because waiting for darker color in a wet week means botrytis. Sort out cracked berries.",
  },
  {
    name: "Cabernet Franc",
    aliases: ["Cab Franc"],
    species: "Vitis vinifera",
    color: "Red",
    hardiness: "Tender here",
    summary: "The red vinifera most likely to ripen on a warm northeastern site. Still tender beside Marquette or Frontenac, and still a late pick.",
    planting: "Grafted, vertical shoot positioning, 4–6 feet, spring, soil pH 6.0–6.8, on a warm site, with the graft union hilled. It needs a longer season than the hybrids. An exposed row without wind protection is a poor bet.",
    maintenance: "Spur pruning works well on a cordon. Leaf-pull on the shade side so late fruit can dry and color. Downy mildew and black rot punish a crowded canopy. Winter injury shows up as dead buds in spring. Leave extra buds until you can see what survived, then adjust. Thin the crop in a cool year.",
    harvesting: "Late September into October. Seeds should be brown, and the flavor should have moved past green bell pepper if you want a ripe style. A little herbal character is normal. Sugar near 21–23 °Brix is a fair target when the season cooperates. Green seeds at a hard freeze mean the fruit will not catch up.",
  },
  {
    name: "Cabernet Sauvignon",
    aliases: ["Cab Sauv"],
    species: "Vitis vinifera",
    color: "Red",
    hardiness: "Tender here",
    summary: "Late, vigorous, and the least realistic red vinifera in this guide for northeast Ohio. It rarely finishes a season here.",
    planting: "Only on a proven warm site. Grafted, vertical shoot positioning, 5–6 feet, soil pH 6.0–6.8, with winter protection of the trunk. If the goal is a ripe red from six vines, Marquette or Petite Pearl matches the climate.",
    maintenance: "This is a large vine with a late season and a heavy spray burden in a humid fall. Spur-prune, thin the crop aggressively, and leaf-pull. Expect winter kill of canes in a cold year. Judge it by whether the fruit ripens before frost, not by whether it grows leaves.",
    harvesting: "October, and often not ripe. If the seeds are green and the taste is vegetal at first frost, it missed the season. A warm year might reach the low 20s °Brix with herbal flavor still present. Pick before a hard freeze if any fruit is usable.",
  },
];

function normalize(value: string): string {
  return value
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
}

function keys(varietal: Varietal): string[] {
  return [varietal.name, ...varietal.aliases].map(normalize);
}

export function allVarietals(): Varietal[] {
  return [...varietals].sort((a, b) => a.name.localeCompare(b.name));
}

export function filterVarietals(query: string): Varietal[] {
  const normalized = normalize(query);
  if (!normalized) return allVarietals();
  return allVarietals().filter((varietal) => keys(varietal).some((key) => key.includes(normalized)));
}

export type ZoneFit = "suited" | "marginal" | "cold" | "warm";

type Trait = { min: number; max: number; marginalAtMin?: boolean; sprayFocus: string };

const traits: Record<string, Trait> = {
  Concord: { min: 4, max: 8, sprayFocus: "Black rot, downy mildew, phomopsis, and grape berry moth. Powdery mildew is usually milder than on vinifera." },
  Niagara: { min: 4, max: 8, sprayFocus: "The same program as Concord. Watch black rot on the early clusters." },
  Catawba: { min: 5, max: 7, sprayFocus: "The same labrusca diseases, carried later because the fruit hangs into fall." },
  Marquette: { min: 4, max: 7, sprayFocus: "Downy mildew and early black rot. Early bud break adds frost risk. It does not move the spray calendar." },
  Frontenac: { min: 4, max: 7, sprayFocus: "Early black rot, then canopy control. Downy mildew is less aggressive than on Marquette." },
  "Frontenac Gris": { min: 4, max: 7, sprayFocus: "Same targets as Frontenac: early black rot, then an open canopy." },
  "Frontenac Blanc": { min: 4, max: 7, sprayFocus: "Same targets as Frontenac: early black rot, then an open canopy." },
  "La Crescent": { min: 4, max: 7, sprayFocus: "Downy mildew and black rot from pre-bloom through bunch closure. Do not stretch the early intervals." },
  Itasca: { min: 4, max: 7, sprayFocus: "Cover the early black-rot window. Decent tolerance is not a reason to skip the pre-bloom spray." },
  "Petite Pearl": { min: 4, max: 7, sprayFocus: "A normal hybrid program. Black rot in a wet May is the spray to respect." },
  Edelweiss: { min: 4, max: 7, sprayFocus: "Black rot on the early clusters. The season starts and ends sooner, so the pre-harvest interval arrives early." },
  Brianna: { min: 4, max: 7, sprayFocus: "Black rot and downy mildew. Early sugar means you run into the pre-harvest interval sooner." },
  "St. Croix": { min: 4, max: 7, sprayFocus: "Standard hybrid covers. Open the fruit zone so the spray reaches the inner berries." },
  "Marechal Foch": { min: 4, max: 7, sprayFocus: "An early harvest, so the post-bloom covers land in midsummer and the pre-harvest interval follows quickly." },
  "Cayuga White": { min: 5, max: 7, sprayFocus: "Early black rot, then botrytis if a rainy September hits a heavy crop." },
  "Seyval Blanc": { min: 5, max: 7, sprayFocus: "Standard covers. Thinning a heavy crop does more for the fruit than an extra late spray." },
  Vignoles: { min: 5, max: 7, sprayFocus: "Botrytis is the specific problem. Leaf pull and the bunch-closure cover matter as much as the early black-rot sprays." },
  Traminette: { min: 5, max: 7, sprayFocus: "Black rot and downy mildew. Keep the crop small so you are not spraying a crowded canopy." },
  "Vidal Blanc": { min: 5, max: 7, sprayFocus: "Standard covers, then botrytis if the fruit stays out for a late harvest." },
  Chambourcin: { min: 6, max: 8, marginalAtMin: true, sprayFocus: "Early sprays still matter. Later tolerance is not a reason to skip the pre-bloom cover in a wet year." },
  Norton: { min: 5, max: 7, sprayFocus: "The shortest list. It resists black rot, downy mildew, and powdery mildew better than the hybrids. A light early program is enough in a wet spring." },
  Riesling: { min: 6, max: 8, marginalAtMin: true, sprayFocus: "Powdery mildew, downy mildew, and botrytis. The pre-bloom and post-bloom covers still have to happen." },
  Chardonnay: { min: 6, max: 8, marginalAtMin: true, sprayFocus: "Powdery mildew first, then downy mildew and botrytis. Early bud break can put the first spray in May." },
  "Gewürztraminer": { min: 6, max: 8, marginalAtMin: true, sprayFocus: "Powdery mildew, and a bunch-closure cover because the clusters are tight." },
  "Pinot Gris": { min: 6, max: 8, marginalAtMin: true, sprayFocus: "Powdery mildew and botrytis. Berries crack after rain, so the late cover and the harvest decision go together." },
  "Pinot Noir": { min: 6, max: 8, marginalAtMin: true, sprayFocus: "Powdery mildew and botrytis. Leaf pull for air, then the bunch-closure spray." },
  "Cabernet Franc": { min: 6, max: 8, marginalAtMin: true, sprayFocus: "Downy mildew and black rot in a crowded canopy. Coverage has to last into September." },
  "Cabernet Sauvignon": { min: 7, max: 10, sprayFocus: "Downy mildew and black rot through a long fall. This is a heavy spray burden in a humid climate." },
};

export function zoneFit(name: string, zone: number): ZoneFit {
  const trait = traits[name];
  if (!trait) return "suited";
  if (zone < trait.min) return "cold";
  if (zone > trait.max) return "warm";
  if (trait.marginalAtMin && zone === trait.min) return "marginal";
  return "suited";
}

export function inRegion(name: string, zone: number): boolean {
  const fit = zoneFit(name, zone);
  return fit === "suited" || fit === "marginal";
}

export function sprayFocusFor(name: string): string {
  return traits[name]?.sprayFocus ?? "Black rot, downy mildew, and powdery mildew are the usual targets.";
}

export const spraySchedule: { when: string; detail: string }[] = [
  { when: "Dormant, before bud swell", detail: "If anthracnose or a bad phomopsis year is already a problem, this is when a dormant fungicide goes on. Skip it when the vine has been clean. The buds should still be tight." },
  { when: "Bud break, shoots about an inch", detail: "Start the protectant season. Phomopsis and black rot infect young tissue in a wet spring. Cover the new green growth before the next rain." },
  { when: "Shoots 3 to 5 inches", detail: "Black rot, downy mildew, and powdery mildew are all active. Leaves that grew after the last spray are unprotected. Keep the interval on the label, and shorten it in a rainy week." },
  { when: "Immediate pre-bloom", detail: "This is the spray that protects the fruit. Clusters are open to black rot and downy mildew as the caps come off. Powdery mildew belongs in the same cover." },
  { when: "Bloom", detail: "Spray again if the last cover has expired or rain washed it off. If the label says to stay off the vines while bees are working, wait until the caps have fallen and keep the labeled interval." },
  { when: "Post-bloom, 10 to 14 days later", detail: "The second cover on the fruit. Black rot can still infect berries for several weeks after bloom. Do not stretch this interval in a humid June." },
  { when: "Bunch closure", detail: "The last chance for spray to reach the inside of the cluster. Tight-clustered varieties need it for botrytis. Loose clusters can often stop once the fruit is past the black-rot window." },
  { when: "Veraison through harvest", detail: "Routine black-rot sprays can stop once the berries are resistant. Later sprays are for downy mildew on the leaves, powdery mildew, and botrytis. The pre-harvest interval on the label is the last day you can spray." },
];
