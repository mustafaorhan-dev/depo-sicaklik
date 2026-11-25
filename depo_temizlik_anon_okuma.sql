-- ============================================================
-- DEPO SICAKLIK + TEMIZLIK (QR / girişsiz sayfa)
-- ------------------------------------------------------------
-- depo-sicaklik/index.html alttaki "Depo Temizliği Kayıtları"
-- bölümünün DEPO PROGRAMI projesindeki (jarnxfhv...) temizlik
-- kayıtlarını okuyabilmesi için anon role SALT SELECT izni verir.
-- YAZMA / DÜZENLEME / SİLME yetkisi VERMEZ.
--
-- Uygulama: Supabase Dashboard > SQL Editor > New query > Run
-- Tekrar tekrar çalıştırılabilir (idempotent), veri değiştirmez.
-- ============================================================

DO $$
BEGIN
  IF to_regclass('public.depo_temizlik_kayitleri') IS NULL THEN
    RAISE EXCEPTION 'depo_temizlik_kayitleri tablosu bulunamadı.';
  END IF;
END $$;

GRANT SELECT ON public.depo_temizlik_kayitleri TO anon;

DROP POLICY IF EXISTS "depo_temizlik_anon_select_public" ON public.depo_temizlik_kayitleri;
CREATE POLICY "depo_temizlik_anon_select_public"
  ON public.depo_temizlik_kayitleri
  FOR SELECT
  TO anon
  -- Yalnızca onaylanmış kayıtlar herkese açıktır; bekleyen/reddedilen kayıtlar gizli kalır.
  USING (durum = 'onayli');
