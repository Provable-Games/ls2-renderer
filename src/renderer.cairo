// SPDX-License-Identifier: MIT
// NFT Renderer for ls2-renderer, replicating death-mountain's metadata logic
use core::array::ArrayTrait;
use ls2_renderer::mock_adventurer::{IMockAdventurerDispatcherTrait, Adventurer, Bag, Equipment, Stats, Item};
use starknet::ContractAddress;
use core::byte_array::ByteArrayTrait;

// Trait for rendering token metadata
pub trait Renderer {
    fn render(token_id: u256, mock_adventurer_addr: ContractAddress) -> ByteArray;
}

// Helper: Convert u256 to u64 (for adventurer_id)
fn u256_to_u64(val: u256) -> u64 {
    // Only use the low 64 bits for mock id
    val.low.try_into().unwrap()
}

// Helper: Deterministic name
fn adventurer_name(adventurer_id: u64) -> ByteArray {
    let mut name: ByteArray = "Adventurer #";
    name += u64_to_string(adventurer_id);
    name
}

// Optimized: Single generic number to string conversion
fn number_to_string(mut n: u64) -> ByteArray {
    let mut out: ByteArray = Default::default();
    if n == 0 {
        out.append_byte('0');
        return out;
    }
    let mut digits: Array<u8> = ArrayTrait::new();
    loop {
        if n == 0 { break; }
        digits.append((n % 10).try_into().unwrap() + '0');
        n = n / 10;
    };
    let mut i = digits.len();
    loop {
        if i == 0 { break; }
        i -= 1;
        out.append_byte(*digits[i]);
    };
    out
}

// Helper: Convert u64 to ByteArray
fn u64_to_string(n: u64) -> ByteArray {
    number_to_string(n)
}

// Helper: Convert u16 to ByteArray
fn u16_to_string(n: u16) -> ByteArray {
    number_to_string(n.into())
}

// Helper: Convert u8 to ByteArray
fn u8_to_string(n: u8) -> ByteArray {
    number_to_string(n.into())
}

// Helper: Convert bool to ByteArray
fn bool_to_string(b: bool) -> ByteArray {
    if b { "true" } else { "false" }
}

// Helper: Convert Item to string
fn item_to_string(item: Item) -> ByteArray {
    let mut s: ByteArray = "{";
    s += "id:" + u8_to_string(item.id) + ",xp:" + u16_to_string(item.xp) + "}";
    s
}

// Optimized: Equipment to string conversion
fn equipment_to_string(e: Equipment) -> ByteArray {
    "{weapon:" + item_to_string(e.weapon) + ",chest:" + item_to_string(e.chest) + ",head:" + item_to_string(e.head) + ",waist:" + item_to_string(e.waist) + ",foot:" + item_to_string(e.foot) + ",hand:" + item_to_string(e.hand) + ",neck:" + item_to_string(e.neck) + ",ring:" + item_to_string(e.ring) + "}"
}

// Optimized: Bag to string conversion
fn bag_to_string(bag: Bag) -> ByteArray {
    let items_str = item_to_string(bag.item_1) + "," + item_to_string(bag.item_2) + "," + item_to_string(bag.item_3) + "," + item_to_string(bag.item_4) + "," + item_to_string(bag.item_5) + "," + item_to_string(bag.item_6) + "," + item_to_string(bag.item_7) + "," + item_to_string(bag.item_8) + "," + item_to_string(bag.item_9) + "," + item_to_string(bag.item_10) + "," + item_to_string(bag.item_11) + "," + item_to_string(bag.item_12) + "," + item_to_string(bag.item_13) + "," + item_to_string(bag.item_14) + "," + item_to_string(bag.item_15);
    "{mutated:" + bool_to_string(bag.mutated) + ",items:[" + items_str + "]}"
}

// Optimized: Stats to string conversion
fn stats_to_string(stats: Stats) -> ByteArray {
    "{strength:" + u8_to_string(stats.strength) + ",dexterity:" + u8_to_string(stats.dexterity) + ",vitality:" + u8_to_string(stats.vitality) + ",intelligence:" + u8_to_string(stats.intelligence) + ",wisdom:" + u8_to_string(stats.wisdom) + ",charisma:" + u8_to_string(stats.charisma) + ",luck:" + u8_to_string(stats.luck) + "}"
}

// Helper: Generate optimized animated SVG with four themed pages
fn svg_image_animated(name: ByteArray, adv: Adventurer) -> ByteArray {
    let mut svg: ByteArray = "<svg width='862' height='1270' viewBox='0 0 862 1270' fill='none' xmlns='http://www.w3.org/2000/svg'>";
    
    // Shared definitions and reusable components
    svg += "<defs>";
    svg += svg_shared_borders();
    svg += svg_gradients(); 
    svg += "</defs>";
    
    // Animated viewport that slides between pages
    svg += "<g id='viewport'>";
    svg += "<animateTransform attributeName='transform' type='translate' values='0,0; 0,0; -862,0; -862,0; -1724,0; -1724,0; -2586,0; -2586,0' dur='40s' repeatCount='indefinite'/>";
    
    // Page 1: Green (Primary Stats)
    svg += svg_page_green(name.clone(), adv);
    
    // Page 2: Orange (Equipment)  
    svg += "<g transform='translate(862,0)'>";
    svg += svg_page_orange(name.clone(), adv);
    svg += "</g>";
    
    // Page 3: Blue (Combat Stats)
    svg += "<g transform='translate(1724,0)'>";
    svg += svg_page_blue(name.clone(), adv);
    svg += "</g>";
    
    // Page 4: Gradient (Overview)
    svg += "<g transform='translate(2586,0)'>";
    svg += svg_page_gradient(name, adv);
    svg += "</g>";
    
    svg += "</g>";
    svg += "</svg>";
    svg
}

// Shared border definitions (reusable across all pages) - FULLY DEFINED UNOPTIMIZED from reference NFT files
fn svg_shared_borders() -> ByteArray {
    let mut borders: ByteArray = "<clipPath id='clip0_19_3058'><rect x='147.203' y='27' width='567' height='862' rx='10' fill='white'/></clipPath>";
    borders += "<g id='frameBorders'>";
    
    // Bottom border complex (main spanning section)
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='M714.415 856.727h-6.246c-.349-2.091.793-6.497-.617-7.878l-.414.029c-1.95.102-4.155-.235-6.048-.072l-.4.043c-.225.03-.487-.061-.624 0v13.938c-.473-.15-.552-.221-.597-.508l-.046-.371c.081.618.007.679.643.879 2.888.915 10.824-.678 14.349 0v26.059h-28.074c-.146-3.954.168-7.978.034-11.936l-.034-.791h-14.972c.052-.414-.262-1.185.256-1.226-.527.035-.21.81-.263 1.226-.237 1.812.037 4.14 0 6.061-.003.057-.605.353-.593.738.001-.38.593-.671.593-.726l.007-.012c1.946 1.436 6.675-.134 8.147.872.923.63.936 4.897 0 5.533-1.497 1.018-11.241-.212-13.768.267-.025-.606.025-1.213 0-1.819l13.107.613v-.012l-13.102-.612c-.031-1.004.025-2.021 0-3.025l-.029-1.965c-.017-1.971.001-3.954.029-5.913l.505.406.001-.005-.506-.407v-1.212c.038-1.81-.031-3.638 0-5.454h28.698v-27.264c6.681 1.412 13.257.054 19.964 0z'/>";
    
    // Left border complex  
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='M152.94 427.672h8.11l-.012-323.257 5.628-.351v341.789H152.94c.58 3.515-1.023 22.023.624 23.635h13.102v341.789l-5.628-.352.012-323.258-.163-.047c-1.768-.446-5.947.435-7.947.047v348.455h-6.238V481.608h14.348v-6.061h-14.348v-34.542h13.724v-6.667h-13.724V80.428h6.238z'/>";
    
    // Right border complex
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='M713.866 433.733h-14.349v7.272h14.349v34.542h-14.349c.349 1.757-.48 5.23 0 6.666h9.981c1.161-.224 2.596-1.12 4.368-.605v354.514h-6.239V487.667h-8.11v323.307c-1.451-.476-5.003.14-5.569-.813l-.045-.096V470.093c-.031-.594.405-.563.904-.624 3.918-.485 8.784.388 12.82.019v-23.635h-13.101l-.623-341.184.047-.095c.627-.941 5.501-.664 5.58-.159l-.013 323.864c1.784 1.733 5.727-.54 8.11 0V80.429h6.239z'/>";
    
    // Bottom left corner
    borders += "<path d='M153.564 868.241c1.585-1.036 5.402-1.005 6.862 0-1.416-.29-5.184-.097-6.862 0'/>";
    
    // Bottom border sections
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='M166.666 868.847c.13.236.423.419.623.606h27.557c.501.024.477.425.535.879.237 1.795.312 16.32-.018 17.302l-.072.199c-.159.398-.276.356-.833.425-3.924.485-8.784-.394-12.827-.013v-4.853h7.494c.137-.406.137-7.467 0-7.878h-14.35c-.099.231.037.83 0 1.212-1.052-.673-1.249-.738-1.266-.334.018-.398.218-.333 1.266.334-.356 3.878.262 8.187 0 12.12h-28.073v-26.059h13.724c.17-.09.44-.342.575-.53l.049-.076v-12.726l-.049-.076a2.3 2.3 0 0 0-.497-.482l-.078-.048h-6.862c-1.41 1.375-.268 5.794-.617 7.885-1.685-.116-3.575.236-5.216-.091-1.61-.321-.448-1.041-.403-1.125.137.254.246.404.334.473l-.055-.052a2 2 0 0 1-.281-.424c-.019-4.236.018-8.49 0-12.726h19.34z'/>";
    
    // Bottom corner detailed structures
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='M181.027 862.793H174.145V855.503H181.027V862.793ZM180.386 862.189L175.398 862.194L175.399 862.199H180.403L180.396 856.103H180.378L180.386 862.189Z'/>";
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='M166.666 830.063H180.39V842.789C185.08 843.153 190.373 842.079 194.924 843.273L195.363 843.395C195.913 843.929 194.8 854.723 195.308 857.127L195.363 857.333L196.093 857.386C199.786 857.586 204.062 856.883 207.559 857.315C208.195 857.393 208.257 857.321 208.462 857.938L208.463 857.939C208.849 859.081 208.469 863.376 208.46 865.437L208.463 865.818C208.488 866.787 208.326 867.95 208.463 868.847L208.47 868.931C208.474 869.127 208.409 869.337 208.463 869.453C208.96 870.507 212.18 870.053 214.186 870.001L214.622 869.997C212.691 869.973 208.998 870.583 208.463 869.453H215.957V875.514H202.855V862.787H189.13V849.457C189.129 849.456 189.126 849.456 189.125 849.455C188.912 849.286 188.669 848.904 188.5 848.849C188.489 848.845 188.477 848.842 188.465 848.838C184.375 848.336 178.599 849.544 174.782 848.843L174.158 848.237C173.794 846.356 174.579 836.789 174.172 836.138C174.16 836.136 174.15 836.134 174.145 836.129L174.151 836.123H161.05V817.943H166.666V830.063Z'/>";
    
    // Right side detailed structures
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='M694.458 818.542C695.739 817.291 698.31 818.172 700.066 817.943V836.123H686.341V848.849H672.623L672.478 848.874C672.119 848.903 671.62 848.748 671.375 848.849C671.061 848.981 670.932 849.043 670.864 849.158C670.934 849.05 671.065 848.989 671.369 848.862V862.793H658.891C660.675 861.296 668.043 862.642 670.75 862.194C670.759 862.185 670.767 862.172 670.775 862.155C670.769 862.166 670.764 862.174 670.757 862.181C668.05 862.635 660.681 861.291 658.897 862.781C658.367 863.224 658.461 863.509 658.274 863.993C658.272 864 658.269 864.006 658.267 864.012V875.52C654.424 875.156 649.801 875.992 646.071 875.543C645.459 875.47 644.611 875.75 644.542 874.913H657.65C657.65 874.911 657.65 874.909 657.65 874.907H644.548C643.444 868.229 646.476 869.478 652.035 869.453C652.159 865.836 651.847 862.159 652.034 858.542C652.032 858.543 652.031 858.544 652.029 858.545C652.048 858.145 651.998 857.733 652.029 857.333H665.125C665.128 857.331 665.132 857.329 665.136 857.327C665.326 857.226 665.642 856.919 665.753 856.731V842.789H680.102C680.05 842.943 680.007 843.053 679.962 843.134C680.009 843.052 680.055 842.938 680.109 842.777C680.845 840.583 679.697 833.922 680.09 830.929C680.171 830.311 680.097 830.251 680.733 830.051C680.738 830.053 680.743 830.054 680.748 830.056C683.42 829.229 690.572 830.676 693.818 830.064C693.823 830.059 693.829 830.056 693.833 830.051C695.341 828.593 694.013 821.021 694.456 818.548H699.442V818.542H694.458Z'/>";
    
    // Right corner
    borders += "<path d='M686.347 862.793H680.09V855.503H686.347V862.793Z'/>";
    
    // Bottom horizontal border (main spanning path)
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='M438.044 862.787C438.388 862.787 437.795 868.641 438.044 869.453C437.59 869.249 437.406 868.624 437.353 867.849L437.335 867.371C437.342 868.36 437.496 869.208 438.039 869.453C438.176 869.514 438.438 869.423 438.663 869.453C438.751 869.526 438.861 869.591 438.992 869.651C438.866 869.593 438.76 869.529 438.674 869.459L438.668 869.453C441.014 869.756 453.115 868.938 453.647 869.453C454.052 873.641 453.079 878.737 453.647 882.791C452.219 878.907 453.398 874.15 453.03 870.06C453.017 870.048 453.001 870.036 452.98 870.026C452.995 870.034 453.007 870.043 453.017 870.053C453.391 874.143 452.213 878.901 453.635 882.785C453.666 883.003 453.573 883.258 453.635 883.392C453.894 883.924 454.125 884.011 454.452 884.02C454.128 884.01 453.898 883.921 453.641 883.392H466.736C466.848 883.331 467.297 882.894 467.36 882.785C467.362 882.782 467.363 882.778 467.365 882.775C467.049 878.402 468.082 873.607 466.742 869.453H633.313V875.52H515.403L632.695 874.919V870.066H632.683V874.913L515.397 875.514H499.183C501.415 875.008 504.04 874.754 506.666 874.754C504.038 874.754 501.41 875.008 499.176 875.514H490.449C491.849 875.221 493.504 874.814 495.098 874.764L495.621 874.761C493.869 874.722 491.999 875.188 490.443 875.514C490.374 875.526 490.062 875.962 489.495 876.108C488.721 876.301 486.882 875.956 486.7 876.119C486.444 876.344 486.893 881.699 486.7 882.791H658.261V888.852H479.836V875.52C477.852 875.81 474.34 874.804 472.974 876.125C471.472 877.579 472.797 885.18 472.357 887.64H472.363C472.806 885.185 471.477 877.58 472.981 876.119V888.852C469.317 888.283 449.737 889.847 448.033 888.244L448.02 888.245C446.262 886.543 448.242 878.055 447.397 875.524C445.365 876.41 434.612 876.432 433.752 875.452C433.31 874.948 433.921 870.641 433.684 869.459L433.677 869.453C433.681 869.453 433.685 869.452 433.689 869.452C433.681 869.452 433.672 869.454 433.665 869.453C431.604 869.357 429.5 869.519 427.439 869.453V869.459H427.437C427.438 869.457 427.438 869.455 427.439 869.453C427.435 869.453 427.43 869.453 427.426 869.453C426.154 869.853 427.052 873.611 426.802 874.907H413.078V887.634H389.383V887.64H413.09V874.913H426.815C427.064 873.617 426.167 869.862 427.437 869.459C427.192 870.293 427.781 876.118 427.439 876.119H414.337V888.846H389.072C387.331 888.846 388.447 877.333 388.135 875.514C388.543 875.532 388.963 875.484 389.371 875.513V875.507C388.959 875.477 388.535 875.531 388.124 875.507C385.763 875.398 383.011 875.398 380.649 875.506V888.846H202.849V883.385H374.411L203.466 883.986V887.627H203.473V883.991L374.411 883.392V875.514H227.797V869.453H394.368V882.18C394.322 882.182 394.247 882.671 393.974 882.78C394.253 882.671 394.329 882.175 394.375 882.18C394.768 882.198 395.616 882.749 396.533 882.785C398.691 882.864 406.919 883.186 408.099 882.18C408.101 882.178 408.103 882.175 408.105 882.173C408.396 878.274 407.7 873.891 408.105 870.066C408.124 869.866 408.086 869.659 408.105 869.459H422.436C422.438 869.455 422.44 869.451 422.442 869.447C422.504 869.314 422.411 869.059 422.442 868.841L422.448 868.847C422.612 868.873 422.758 868.877 422.887 868.861C422.759 868.877 422.616 868.872 422.455 868.847H422.448C422.672 867.108 422.647 864.563 422.448 862.787H438.044Z'/>";
    
    // Top border complex
    borders += "<path d='M658.261 52.538l.006.015c.081.188-.093.508 0 .605h13.732V66.49c-.473-.15-.553-.22-.597-.508l-.046-.37c.081.618.006.678.643.878 2.121.673 10.549-.2 13.724 0 .21.012.414-.012.618 0l.612.31c-.018.142-.539.21-.605.282l-.007.015c-.174 4.018.163 8.102 0 12.12-.014.345.105 1.219-.18 1.234.293-.003.172-.887.186-1.234.505.212.493 1.09.624 1.212h13.101c-.499 5.054.661 11.181.012 16.09-.08.607-.007.677-.629.874v.005c-1.111.351-3.631-.249-4.997 0-.138-3.818.193-7.703 0-11.52-.019-.4.031-.813 0-1.213h-12.484c-.306-1.527.424-9.148 0-9.702-.106-.14-1.11.14-1.248 0-.069-.067-.343-1.176-.624-1.818a.3.3 0 0 1-.018-.06l-.004-.057a.3.3 0 0 0 .022.128c-4.56-.224-9.295.583-13.725-.605v-13.03c0-.066-.864-.906-.935-.909h-12.789c-.393-4.005.53-8.847 0-12.725.468 1.204.654 2.504.709 3.844-.054-1.345-.239-2.65-.709-3.857-.031-.218.062-.472 0-.605v.012c-.271-.568-1.328-.698-2.56-.689 1.229-.009 2.283.122 2.553.689h-8.11v-5.455h13.725z'/>";
    
    // Top left connection
    borders += "<path d='M174.152 80.4289C173.946 81.041 173.883 80.9742 173.247 81.0529C171.381 81.2831 162.08 80.6355 161.668 81.0354V97.4035C161.038 97.2035 161.113 97.1367 161.032 96.5246C160.383 91.6159 161.544 85.483 161.044 80.4289H174.152Z'/>";
    
    // Top border construction
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='M665.772 27.7c4.214-1.378 9.296-.225 13.713-.606-.194 1.497.268 3.455 0 4.854l-.009.008c-.086.445-.156.512-.614.596l-.001.002c-1.959.357-4.766-.248-6.862 0 .018-.398-.031-.808 0-1.206h-.007c-.031.4.025.806 0 1.206-.119 2.406.087 4.866 0 7.278 3.525-.685 11.46.915 14.355 0 .63-.2.562-.26.643-.879.455-3.442-.368-7.696-.019-11.24h26.196v-.007h-26.202c-.349 3.545.468 7.8.019 11.241-.081.618-.007.68-.643.88V27.1h28.074v25.453h-14.349V66.49a1.4 1.4 0 0 1-.388-.184c.094.07.221.135.394.191.967.31 7.717.188 8.11-.606l.611-.303-.009-.005-.608.302c.063-.127-.031-.388 0-.607l.006.003c.18-1.253-.043-2.888 0-4.238.879-2.01 3.071-1.058 4.985-1.213v-.006c-1.916.158-4.111-.799-4.991 1.212.019-.605-.025-1.217 0-1.817h6.244c-.667 3.418.892 10.441 0 13.332l-.006.002c-.074.248-.001.49-.368.55-.49.145-1.006.024-1.497.053-5.939.357-12.134-.26-18.098 0-.031-.4.025-.806 0-1.212h.007c-.405-8.058.854-17.412.031-25.203-.088-.848-.05-.867-.656-1.455l-.007-.007c-3.295-.38-27.599.752-28.073-.605h.005c-1.124-3.23.844-12.959.002-16.962l-.007-.006h13.108v3.636h.006V27.7z'/>";
    
    // Top left border construction  
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='M181.353 27.6c4.149-1.221 9.08-.146 13.386-.5-.484.43-1.749.615-3.326.674 1.579-.06 2.847-.244 3.333-.674.872-.145.592 1 .629 1.51.169 2.17.399 14.899-.006 16.064h-.006c-.386 1.104-16.536.562-24.323.525l-3.751.082c-.2.048-.468-.073-.623 0-.476.22-.655 2.861-.703 6.413.048-3.549.227-6.187.703-6.408v27.877c-.618-.484-1.173 0-1.56 0h-18.404V59.225h6.245v6.06l-.006-.004c.068.092-.276 1.042.411 1.222.562.145 7.243.133 7.698-.013.924-.296.569-.811.65-1.484V65c-.088.673.267 1.188-.65 1.485V52.553h-14.348V27.1h28.073v12.726c-.412-.018-.836.03-1.247 0a2 2 0 0 1-.025-.186v.006q.01.105.025.186c.411.03.829-.024 1.247 0 4.754.224 9.595-.17 14.355 0v-7.278l-8.116.007v-4.855c.05-.048.166-.081.339-.105'/>";
    
    // Top corner detailed structures
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='M181.353 27.6008C185.502 26.3786 190.433 27.4537 194.739 27.0998C194.255 27.5301 192.99 27.7147 191.413 27.7736C192.992 27.7148 194.26 27.5303 194.746 27.0998C195.618 26.9549 195.338 28.1006 195.375 28.6096C195.544 30.7803 195.774 43.509 195.369 44.674H195.363C194.977 45.7779 178.827 45.2355 171.04 45.1994L167.289 45.2805C167.089 45.3286 166.821 45.2081 166.666 45.2805C166.19 45.5015 166.011 48.1421 165.963 51.6945C166.011 48.1451 166.19 45.5073 166.666 45.2863V73.1633C166.048 72.6786 165.493 73.1629 165.106 73.1633H146.702V59.2248H152.947V65.2844C152.945 65.283 152.943 65.2826 152.941 65.2814C153.009 65.373 152.665 66.3227 153.352 66.5031C153.914 66.6485 160.595 66.6359 161.05 66.4904C161.974 66.1935 161.619 65.6787 161.7 65.0061C161.728 64.7836 161.752 64.5554 161.774 64.3225C161.752 64.5533 161.728 64.7797 161.7 65.0002C161.612 65.6728 161.967 66.1876 161.05 66.4846V52.5529H146.702V27.0998H174.775V39.8264C174.363 39.8083 173.939 39.8566 173.528 39.8264C173.518 39.7725 173.51 39.7101 173.503 39.6398V39.6457C173.51 39.716 173.518 39.7783 173.528 39.8322C173.939 39.8625 174.357 39.8081 174.775 39.8322C179.529 40.0565 184.37 39.6626 189.13 39.8322V32.5539L181.014 32.5607V27.7063C181.064 27.6582 181.18 27.625 181.353 27.6008Z'/>";
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='M181.02 60.4367L174.132 60.4426V53.1525L181.02 53.1467V60.4367ZM180.396 59.2307H180.403V53.7522H180.396V59.2307Z'/>";
    
    // Additional top sections
    borders += "<path d='M679.479 52.5529C688.443 51.644 687.108 53.4742 686.971 61.0432H679.479V52.5529Z'/>";
    borders += "<path fill-rule='evenodd' clip-rule='evenodd' d='m380.026 40.029.006.003c.424.134 8.31.134 8.734 0 .63-.2.562-.26.643-.879.427-3.226-.271-7.167-.072-10.568l.053-.673h-.007c-.349 3.545.468 7.8.019 11.241-.081.619-.006.68-.643.88V27.1h26.202v12.12c-.169-.015-.875.638-1.151.646.279-.005.989-.662 1.158-.646.107.013.693.595 1.516.625 1.728.06 11.18-.418 11.592-.024.242.24-.181 5.042 0 6.066 8.608.254 4.965-1.007 6.325-5.073.83-2.466 11.666.315 13.638-1.6 1.508-1.465.177-9.04.623-11.508h-.012c-.449 2.46.886 10.046-.623 11.514V27.1h25.578l-.624 12.716q.006.001.013.005c.928.296 5.979.073 7.473 0V27.1h178.424v5.46H486.718l-.176.466c-.797 2.305-.395 4.29-.454 6.812h146.599l.002-.012c1.273.406.374 4.158.624 5.455H466.742V32.557c-2.674-.834-9.856.627-13.095.004-.031 2.212.056 4.454 0 6.672h-.007c-.012.602.02 1.203.001 1.805a.72.72 0 0 1-.598-.432c.11.237.311.418.604.445-.025.806.025 1.618 0 2.424l-.007.01c-.017.599.032 1.203.001 1.796h-14.329l-.014.011c-1.503 1.467-.075 4.46-.624 6.06h-.01c-.307.882-.835.54-1.524.619-2.838.34-10.961.339-13.794-.013-.636-.078-.698-.006-.904-.624h.007c-.442-1.363.459-4.696.006-6.042l-.002-.006h-14.354V32.561c-.68-.218-13.669-.218-14.349 0v12.72H226.556c.25-1.297-.649-5.048.623-5.455v.006h147.226c-1.285-2.333.118-5.162-.624-7.271l.006-.007H202.855l-.006-5.454h176.553z'/>";
    borders += "<path d='M438.668 32.554h-16.22V27.1h16.22z'/>";
    
    borders += "</g>";
    borders
}

// Gradient definitions for the system
fn svg_gradients() -> ByteArray {
    let mut gradients: ByteArray = "<linearGradient id='orangeGrad' x1='0%' y1='0%' x2='100%' y2='100%'>";
    gradients += "<stop offset='0%' style='stop-color:#FE9676'/>";
    gradients += "<stop offset='100%' style='stop-color:#E89446'/>";
    gradients += "</linearGradient>";
    gradients += "<linearGradient id='blueGrad' x1='0%' y1='0%' x2='100%' y2='100%'>";
    gradients += "<stop offset='0%' style='stop-color:#77EDFF'/>";
    gradients += "<stop offset='100%' style='stop-color:#68CFDF'/>";
    gradients += "</linearGradient>";
    gradients
}

// Page 1: Green theme - Primary Stats
fn svg_page_green(name: ByteArray, adv: Adventurer) -> ByteArray {
    let mut page: ByteArray = "<g clip-path='url(#clip0_19_3058)'>";
    page += "<rect x='147.203' y='27' width='567' height='862' rx='10' fill='#000'/>";
    page += "<use href='#frameBorders' fill='#78E846'/>";
    
    // Title
    page += "<text x='431' y='80' font-family='monospace' font-size='24' font-weight='bold' fill='#78E846' text-anchor='middle'>" + name + "</text>";
    page += "<text x='431' y='105' font-family='monospace' font-size='12' fill='#78E846' text-anchor='middle'>PRIMARY STATS</text>";
    
    // Health bar  
    page += "<rect x='200' y='130' width='462' height='20' rx='10' fill='#2B5418'/>";
    page += "<rect x='205' y='135' width='" + u16_to_string((adv.health * 452) / 150) + "' height='10' rx='5' fill='#78E846'/>";
    page += "<text x='431' y='168' font-family='monospace' font-size='14' fill='#78E846' text-anchor='middle'>HP: " + u16_to_string(adv.health) + "/150</text>";
    
    // Core stats grid
    page += "<text x='280' y='200' font-family='monospace' font-size='16' fill='#78E846'>STR</text>";
    page += "<text x='350' y='200' font-family='monospace' font-size='24' fill='#78E846'>" + u8_to_string(adv.stats.strength) + "</text>";
    page += "<text x='480' y='200' font-family='monospace' font-size='16' fill='#78E846'>DEX</text>";
    page += "<text x='550' y='200' font-family='monospace' font-size='24' fill='#78E846'>" + u8_to_string(adv.stats.dexterity) + "</text>";
    
    page += "<text x='280' y='240' font-family='monospace' font-size='16' fill='#78E846'>VIT</text>";
    page += "<text x='350' y='240' font-family='monospace' font-size='24' fill='#78E846'>" + u8_to_string(adv.stats.vitality) + "</text>";
    page += "<text x='480' y='240' font-family='monospace' font-size='16' fill='#78E846'>INT</text>";
    page += "<text x='550' y='240' font-family='monospace' font-size='24' fill='#78E846'>" + u8_to_string(adv.stats.intelligence) + "</text>";
    
    page += "<text x='280' y='280' font-family='monospace' font-size='16' fill='#78E846'>WIS</text>";
    page += "<text x='350' y='280' font-family='monospace' font-size='24' fill='#78E846'>" + u8_to_string(adv.stats.wisdom) + "</text>";
    page += "<text x='480' y='280' font-family='monospace' font-size='16' fill='#78E846'>CHA</text>";
    page += "<text x='550' y='280' font-family='monospace' font-size='24' fill='#78E846'>" + u8_to_string(adv.stats.charisma) + "</text>";
    
    page += "<text x='380' y='320' font-family='monospace' font-size='16' fill='#78E846'>LUCK</text>";
    page += "<text x='450' y='320' font-family='monospace' font-size='24' fill='#78E846'>" + u8_to_string(adv.stats.luck) + "</text>";
    
    // Experience and level info
    page += "<text x='431' y='380' font-family='monospace' font-size='18' fill='#78E846' text-anchor='middle'>XP: " + u16_to_string(adv.xp) + "</text>";
    page += "<text x='431' y='410' font-family='monospace' font-size='14' fill='#78E846' text-anchor='middle'>Gold: " + u16_to_string(adv.gold) + "</text>";
    
    page += "</g>";
    page
}

// Page 2: Orange theme - Equipment
fn svg_page_orange(name: ByteArray, adv: Adventurer) -> ByteArray {
    let mut page: ByteArray = "<g clip-path='url(#clip0_19_3058)'>";
    page += "<rect x='147.203' y='27' width='567' height='862' rx='10' fill='#000'/>";
    page += "<use href='#frameBorders' fill='#E89446'/>";
    
    page += "<text x='431' y='80' font-family='monospace' font-size='24' font-weight='bold' fill='#E89446' text-anchor='middle'>" + name + "</text>";
    page += "<text x='431' y='105' font-family='monospace' font-size='12' fill='#E89446' text-anchor='middle'>EQUIPMENT</text>";
    
    // Equipment grid
    page += svg_equipment_slot(250, 150, "WEAPON", adv.equipment.weapon, "#E89446");
    page += svg_equipment_slot(400, 150, "CHEST", adv.equipment.chest, "#E89446");
    page += svg_equipment_slot(550, 150, "HEAD", adv.equipment.head, "#E89446");
    
    page += svg_equipment_slot(250, 250, "WAIST", adv.equipment.waist, "#E89446");
    page += svg_equipment_slot(400, 250, "FOOT", adv.equipment.foot, "#E89446");
    page += svg_equipment_slot(550, 250, "HAND", adv.equipment.hand, "#E89446");
    
    page += svg_equipment_slot(325, 350, "NECK", adv.equipment.neck, "#E89446");
    page += svg_equipment_slot(475, 350, "RING", adv.equipment.ring, "#E89446");
    
    page += "</g>";
    page
}

// Page 3: Blue theme - Combat Stats
fn svg_page_blue(name: ByteArray, adv: Adventurer) -> ByteArray {
    let mut page: ByteArray = "<g clip-path='url(#clip0_19_3058)'>";
    page += "<rect x='147.203' y='27' width='567' height='862' rx='10' fill='#000'/>";
    page += "<use href='#frameBorders' fill='#68CFDF'/>";
    
    page += "<text x='431' y='80' font-family='monospace' font-size='24' font-weight='bold' fill='#68CFDF' text-anchor='middle'>" + name + "</text>";
    page += "<text x='431' y='105' font-family='monospace' font-size='12' fill='#68CFDF' text-anchor='middle'>COMBAT STATUS</text>";
    
    // Combat stats
    let calculated_attack = adv.stats.strength + (adv.equipment.weapon.id / 10);
    let calculated_defense = adv.stats.vitality + (adv.equipment.chest.id / 10);
    
    page += "<text x='280' y='180' font-family='monospace' font-size='16' fill='#68CFDF'>ATTACK</text>";
    page += "<text x='380' y='180' font-family='monospace' font-size='32' fill='#68CFDF'>" + u8_to_string(calculated_attack) + "</text>";
    
    page += "<text x='480' y='180' font-family='monospace' font-size='16' fill='#68CFDF'>DEFENSE</text>";
    page += "<text x='580' y='180' font-family='monospace' font-size='32' fill='#68CFDF'>" + u8_to_string(calculated_defense) + "</text>";
    
    // Beast encounter info
    page += "<text x='431' y='250' font-family='monospace' font-size='18' fill='#68CFDF' text-anchor='middle'>CURRENT BEAST</text>";
    page += "<text x='431' y='280' font-family='monospace' font-size='16' fill='#68CFDF' text-anchor='middle'>HP: " + u16_to_string(adv.beast_health) + "</text>";
    page += "<text x='431' y='310' font-family='monospace' font-size='14' fill='#68CFDF' text-anchor='middle'>Actions: " + u16_to_string(adv.action_count) + "</text>";
    
    page += "</g>";
    page
}

// Page 4: Gradient theme - Overview
fn svg_page_gradient(name: ByteArray, adv: Adventurer) -> ByteArray {
    let mut page: ByteArray = "<g clip-path='url(#clip0_19_3058)'>";
    page += "<rect x='147.203' y='27' width='567' height='862' rx='10' fill='#000'/>";
    page += "<use href='#frameBorders' fill='url(#orangeGrad)'/>";
    
    page += "<text x='431' y='80' font-family='monospace' font-size='24' font-weight='bold' fill='#FE9676' text-anchor='middle'>" + name + "</text>";
    page += "<text x='431' y='105' font-family='monospace' font-size='12' fill='#FE9676' text-anchor='middle'>ADVENTURER OVERVIEW</text>";
    
    // Overview stats
    page += "<text x='300' y='150' font-family='monospace' font-size='14' fill='#FE9676'>Health: " + u16_to_string(adv.health) + "</text>";
    page += "<text x='500' y='150' font-family='monospace' font-size='14' fill='#FE9676'>XP: " + u16_to_string(adv.xp) + "</text>";
    page += "<text x='300' y='180' font-family='monospace' font-size='14' fill='#FE9676'>Gold: " + u16_to_string(adv.gold) + "</text>";
    page += "<text x='500' y='180' font-family='monospace' font-size='14' fill='#FE9676'>Upgrades: " + u8_to_string(adv.stat_upgrades_available) + "</text>";
    
    // Total power calculation
    let total_stats = adv.stats.strength + adv.stats.dexterity + adv.stats.vitality + adv.stats.intelligence + adv.stats.wisdom + adv.stats.charisma + adv.stats.luck;
    page += "<text x='431' y='230' font-family='monospace' font-size='20' fill='#FE9676' text-anchor='middle'>TOTAL POWER</text>";
    page += "<text x='431' y='260' font-family='monospace' font-size='36' fill='#FE9676' text-anchor='middle'>" + u8_to_string(total_stats) + "</text>";
    
    page += "</g>";
    page
}

// Helper: Equipment slot display
fn svg_equipment_slot(x: u16, y: u16, label: ByteArray, item: Item, color: ByteArray) -> ByteArray {
    let mut slot: ByteArray = "<rect x='" + u16_to_string(x) + "' y='" + u16_to_string(y) + "' width='60' height='60' rx='5' fill='#1a1a1a' stroke='" + color.clone() + "' stroke-width='2'/>";
    
    if item.id > 0 {
        slot += "<rect x='" + u16_to_string(x + 5) + "' y='" + u16_to_string(y + 5) + "' width='50' height='50' rx='3' fill='" + color.clone() + "'/>";
        slot += "<text x='" + u16_to_string(x + 30) + "' y='" + u16_to_string(y + 35) + "' font-family='monospace' font-size='12' fill='#000' text-anchor='middle'>" + u8_to_string(item.id) + "</text>";
    }
    
    slot += "<text x='" + u16_to_string(x + 30) + "' y='" + u16_to_string(y + 80) + "' font-family='monospace' font-size='10' fill='" + color + "' text-anchor='middle'>" + label + "</text>";
    slot
}

// Base64 encoding utilities (adapted from death-mountain)
fn get_base64_char_set() -> Array<u8> {
    array![
        'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
        'Q','R','S','T','U','V','W','X','Y','Z',
        'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p',
        'q','r','s','t','u','v','w','x','y','z',
        '0','1','2','3','4','5','6','7','8','9','+','/'
    ]
}

// Helper: Extract u8 from Option<u8> or panic
fn get_u8(opt: Option<u8>) -> u8 {
    match opt {
        Option::Some(val) => val,
        Option::None(_) => panic!("ByteArray out of bounds"),
    }
}

// Optimized base64 encoding
fn bytes_base64_encode(mut bytes: ByteArray) -> ByteArray {
    let base64_chars = get_base64_char_set();
    let mut result: ByteArray = Default::default();
    if ByteArrayTrait::len(@bytes) == 0 {
        return result;
    }
    let mut p: u8 = 0;
    let c = ByteArrayTrait::len(@bytes) % 3;
    if c == 1 {
        p = 2;
        ByteArrayTrait::append_byte(ref bytes, 0_u8);
        ByteArrayTrait::append_byte(ref bytes, 0_u8);
    } else if c == 2 {
        p = 1;
        ByteArrayTrait::append_byte(ref bytes, 0_u8);
    }
    let mut i = 0;
    let bytes_len = ByteArrayTrait::len(@bytes);
    let last_iteration = bytes_len - 3;
    loop {
        if i == bytes_len {
            break;
        }
        let b0: u32 = get_u8(ByteArrayTrait::at(@bytes, i)).into();
        let b1: u32 = get_u8(ByteArrayTrait::at(@bytes, i + 1)).into();
        let b2: u32 = get_u8(ByteArrayTrait::at(@bytes, i + 2)).into();
        let n: u32 = b0 * 65536 + b1 * 256 + b2;
        let e1 = (n / 262144) & 63;
        let e2 = (n / 4096) & 63;
        let e3 = (n / 64) & 63;
        let e4 = n & 63;
        if i == last_iteration {
            if p == 2 {
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e1));
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e2));
                ByteArrayTrait::append_byte(ref result, 61);
                ByteArrayTrait::append_byte(ref result, 61);
            } else if p == 1 {
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e1));
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e2));
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e3));
                ByteArrayTrait::append_byte(ref result, 61);
            } else {
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e1));
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e2));
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e3));
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e4));
            }
        } else {
            ByteArrayTrait::append_byte(ref result, *base64_chars.at(e1));
            ByteArrayTrait::append_byte(ref result, *base64_chars.at(e2));
            ByteArrayTrait::append_byte(ref result, *base64_chars.at(e3));
            ByteArrayTrait::append_byte(ref result, *base64_chars.at(e4));
        }
        i += 3;
    };
    result
}

// Optimized JSON metadata generation
fn json_metadata(adventurer_id: u64, name: ByteArray, svg: ByteArray, adv: Adventurer, bag: Bag) -> ByteArray {
    let image = "data:image/svg+xml;base64," + bytes_base64_encode(svg);
    let mut json: ByteArray = "{";
    json += "\"name\":\"" + name + "\",";
    json += "\"description\":\"On-chain NFT Adventurer\",";
    json += "\"image\":\"" + image + "\",";
    json += "\"attributes\":[";
    json += "{\"trait_type\":\"Health\",\"value\":\"" + u16_to_string(adv.health) + "\"},";
    json += "{\"trait_type\":\"XP\",\"value\":\"" + u16_to_string(adv.xp) + "\"},";
    json += "{\"trait_type\":\"Gold\",\"value\":\"" + u16_to_string(adv.gold) + "\"},";
    json += "{\"trait_type\":\"Beast Health\",\"value\":\"" + u16_to_string(adv.beast_health) + "\"},";
    json += "{\"trait_type\":\"Stat Upgrades Available\",\"value\":\"" + u8_to_string(adv.stat_upgrades_available) + "\"},";
    json += "{\"trait_type\":\"Action Count\",\"value\":\"" + u16_to_string(adv.action_count) + "\"},";
    json += "{\"trait_type\":\"Item Specials Seed\",\"value\":\"" + u16_to_string(adv.item_specials_seed) + "\"},";
    json += "{\"trait_type\":\"Stats\",\"value\":\"" + stats_to_string(adv.stats) + "\"},";
    json += "{\"trait_type\":\"Equipment\",\"value\":\"" + equipment_to_string(adv.equipment) + "\"},";
    json += "{\"trait_type\":\"Bag\",\"value\":\"" + bag_to_string(bag) + "\"}";
    json += "]}";
    json
}

pub impl RendererImpl of Renderer {
    fn render(token_id: u256, mock_adventurer_addr: ContractAddress) -> ByteArray {
        let adventurer_id = u256_to_u64(token_id);
        let mut dispatcher = ls2_renderer::mock_adventurer::IMockAdventurerDispatcher { contract_address: mock_adventurer_addr };
        let adv = dispatcher.get_adventurer(adventurer_id);
        let bag = dispatcher.get_bag(adventurer_id);
        let name = adventurer_name(adventurer_id);
        let svg = svg_image_animated(name.clone(), adv);
        json_metadata(adventurer_id, name, svg, adv, bag)
    }
}