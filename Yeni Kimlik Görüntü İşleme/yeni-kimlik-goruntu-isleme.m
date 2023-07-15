pkg load image

% Yeni kimlik fotoğrafını yükle
inputImage = imread('yeni_kimlik.jpeg');

% Görüntüyü gri tonlamalıya dönüştür
grayImage = rgb2gray(inputImage);

% Eşik değerini belirle (örneğin, 128)
threshold = 175;

% Görüntüyü eşikle ve binary görüntüye dönüştür
binaryImage = grayImage > threshold;
binaryImage = uint8(binaryImage) * 255;

% Görüntü üzerinde kenarları bul
edgeImage = edge(binaryImage, 'Canny');

% Kenar piksellerini bul
[row, col] = find(edgeImage);

% Kenar piksellerinin en sol, en sağ, en üst ve en alt koordinatlarını bul
leftmost = min(col);
rightmost = max(col);
topmost = min(row);
bottommost = max(row);

% Kenar piksellerinin koordinatlarını kullanarak köşe noktalarını belirle
topLeft = [leftmost, topmost];
topRight = [rightmost, topmost];
bottomLeft = [leftmost, bottommost];
bottomRight = [rightmost, bottommost];

% Köşe noktalarını işaretlemek için görüntü üzerine çiz
outputImage = inputImage;
outputImage = line([topLeft(1), topRight(1)], [topLeft(2), topRight(2)], 'Color', 'red');
outputImage = line([topLeft(1), bottomLeft(1)], [topLeft(2), bottomLeft(2)], 'Color', 'red');
outputImage = line([bottomLeft(1), bottomRight(1)], [bottomLeft(2), bottomRight(2)], 'Color', 'red');
outputImage = line([bottomRight(1), topRight(1)], [bottomRight(2), topRight(2)], 'Color', 'red');


% Maskeleme yapılmış görüntüyü renklendir
coloredMaskedImage = inputImage;
coloredMaskedImage(repmat(~binaryImage, [1, 1, 3])) = 0;


%300 dpi yap
resizedImage = imresize(coloredMaskedImage, [size(coloredMaskedImage, 1)*300/size(coloredMaskedImage, 2), 300]);

% Görüntü matrisini oluştur ve boyutlandır
outputMatrix = imresize(binaryImage, [size(resizedImage, 1), size(resizedImage, 2)]);

% Maskelenmiş görüntünün her pikseli için indis değerini hesaplayarak kopyala
for row = 1:size(resizedImage, 1)
    for col = 1:size(resizedImage, 2)
        if binaryImage(row, col) > 0
            outputMatrix(row, col, :) = resizedImage(row, col, :);
        end
    end
end
% Medyan filtresi için filtre boyutunu belirleyin
filterSize = 2; % Filtre boyutunu istediğiniz değerle değiştirin

% R, G ve B kanallarını ayrı ayrı filtreleyin
filteredImageR = medfilt2(resizedImage(:,:,1), [filterSize filterSize]);
filteredImageG = medfilt2(resizedImage(:,:,2), [filterSize filterSize]);
filteredImageB = medfilt2(resizedImage(:,:,3), [filterSize filterSize]);

% Filtrelenmiş kanalları birleştirerek yeni görüntü oluşturun
filteredResizedImage = cat(3, filteredImageR, filteredImageG, filteredImageB);

%outputMatrix için uygulanan medyan filtre
% Medyan filtresi için filtre boyutunu belirleyin
filterSize = 2; % Filtre boyutunu istediğiniz değerle değiştirin

% Tek kanallı görüntü üzerinde medyan filtresi uygula
filteredOutputMatrix = medfilt2(outputMatrix, [filterSize filterSize]);

%çıktılar
figure;
imshow(inputImage);
title('Giriş Görüntüsü');

figure;
imshow(binaryImage);
title('Maskeleme Yapılmış Görüntü');

figure;
imshow(edgeImage);
title('Kenar Çizgilerini İçeren Görüntü');

figure;
imshow(coloredMaskedImage);
title('Renklendirilmiş Maskeleme Yapılmış Görüntü');

figure;
imshow(resizedImage);
title('300 DPI Yapılmış Görüntü');

figure;
imshow(outputMatrix);
title('İndis Değerleri Kopyalanmış Görüntü');

figure;
imshow(filteredOutputMatrix);
title('İndis Değerleri Kopyalanmış Filtrelenmiş Görüntü');

figure;
imshow(filteredResizedImage);
title('İstenilen Çıkış Formatındaki Filtrelenmiş Görüntü');

imwrite(filteredResizedImage, 'elde_edilen_goruntu_cikis_dosyasi.jpeg');



