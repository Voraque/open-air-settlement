import net.fabricmc.api.ModInitializer;
import net.fabricmc.fabric.api.event.lifecycle.v1.ServerLifecycleEvents;
import net.minecraft.*;
public class VillageAudit implements ModInitializer {
 static void check(boolean b,String s){if(!b)throw new AssertionError(s);System.out.println("OAS_TEST_PASS "+s);}
 static String id(class_1799 s){return class_7923.field_41178.method_10221(s.method_7909()).toString();}
 static class_1646 villager(class_3218 w,class_3852 p,int level){class_1646 v=class_1299.field_6077.method_5883(w);v.method_7195(v.method_7231().method_16921(p).method_16920(1));v.method_8264();try { var m=class_1646.class.getDeclaredMethod("method_16918");m.setAccessible(true);for(int n=1;n<level;n++)m.invoke(v); }catch(Exception e){throw new RuntimeException(e);}return v;}
 static String offers(class_1646 v){return v.method_5647(new class_2487()).method_10562("Offers").toString();}
 public void onInitialize(){ServerLifecycleEvents.SERVER_STARTED.register(server->{try{
 var w=server.method_30002();
 for(var profession:new class_3852[]{class_3852.field_17052,class_3852.field_17064,class_3852.field_17065}){
 var v=villager(w,profession,5);var list=v.method_8264();check(!list.isEmpty()&&list.size()<=10,"smith_offers_load_"+profession);
 for(var t:list){check(!id(t.method_8250()).startsWith("minecraft:diamond_"),"no_diamond_gear_shortcut");check(t.method_8248()>0&&t.method_8248()<=64,"finite_stock");}
 String before=offers(v);class_2487 n=v.method_5647(new class_2487());var restored=villager(w,profession,5);restored.method_5651(n);check(before.equals(offers(restored)),"offers_nbt_roundtrip");
 }
 boolean iron=false,sand=false; for(int i=0;i<32;i++){var a=villager(w,class_3852.field_17052,5);for(var t:a.method_8264())if(id(t.method_8250()).equals("minecraft:iron_ingot")){check(t.method_8246().method_7947()==8&&t.method_8250().method_7947()==3,"upstream_iron_price");iron=true;}var m=villager(w,class_3852.field_17061,5);if(m.method_8264().stream().anyMatch(t->id(t.method_8250()).equals("minecraft:sand")))sand=true;} check(iron&&sand,"renewable_resources_available");
 var lib=villager(w,class_3852.field_17060,5);lib.method_8264();String first=offers(lib);boolean changed=false;
 for(int i=1;i<=5;i++){w.method_29199(24000L*i+2000);lib.method_19182();if(!first.equals(offers(lib)))changed=true;}
 check(changed,"real_restock_rotates_librarian");
 var one=villager(w,class_3852.field_17060,1);String original=offers(one);
 one.method_7195(one.method_7231().method_16921(class_7923.field_41195.method_10223(class_2960.method_60654("minecraft:none"))));
 one.method_7195(one.method_7231().method_16921(class_3852.field_17060));one.method_8264();
 System.out.println("OAS_WORKSTATION_PROTECTION_VERIFIED="+original.equals(offers(one)));

 for(var profession:class_7923.field_41195){if(class_7923.field_41195.method_10221(profession).toString().startsWith("minecraft:"))continue;var v=villager(w,profession,5);v.method_8264();System.out.println("OAS_PROFESSION "+profession+" offers="+v.method_8264().size());check(!v.method_8264().isEmpty(),"modded_profession_has_offers_"+profession);}
 System.out.println("OAS_VILLAGE_AUDIT_COMPLETE");
 }catch(Throwable t){System.out.println("OAS_VILLAGE_AUDIT_FAILED");t.printStackTrace();}});}
}