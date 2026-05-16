import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/repositories/market_place_repository.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_state.dart';
import 'package:sun_gate_app/features/marketplace/presentation/provider/market_place_provider.dart';

final marketPlaceControllerProvider =
    StateNotifierProvider<MarketPlaceController, MarketPlaceState>((ref) {
      final repository = ref.read(marketPlaceRepositoryProvider);

      return MarketPlaceController(repository: repository);
    });

class MarketPlaceController extends StateNotifier<MarketPlaceState> {
  static const _ownedProductKeysPrefsKey = 'marketplace_owned_product_keys';

  final MarketPlaceRepository repository;

  MarketPlaceController({required this.repository})
    : super(MarketPlaceState.initial()) {
    _loadOwnedProductKeys();
    getCompanies();
    getProducts();
  }

  Future<void> getCompanies() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final companies = await repository.getCompanies();

      state = state.copyWith(isLoading: false, companies: companies);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<CompanyEntity?> getMyCompany() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final company = await repository.getMyCompany();
      state = state.copyWith(isLoading: false, myCompany: company);
      return company;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        myCompany: null,
        errorMessage: null,
      );
      return null;
    }
  }

  Future<void> getEngineers({String? companyId}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final engineers = await repository.getEngineers(companyId: companyId);
      state = state.copyWith(isLoading: false, engineers: engineers);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> getProducts() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final products = await repository.getProducts();

      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> updateCompany(UpdateCompanyRequestDto request) async {
    if (state.myCompany == null) return false;

    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final updatedCompany = await repository.updateCompany(
        companyId: state.myCompany!.id,
        request: request,
      );
      state = state.copyWith(
        isSaving: false,
        myCompany: updatedCompany,
        successMessage: 'Company updated successfully',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: _errorMessage(e),
      );
      return false;
    }
  }

  Future<bool> uploadCompanyLogo({required String filePath}) async {
    final company = state.myCompany;
    if (company == null) return false;

    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final updatedCompany = await repository.uploadCompanyLogo(
        companyId: company.id,
        filePath: filePath,
      );

      state = state.copyWith(
        isSaving: false,
        myCompany: updatedCompany,
        successMessage: 'Company logo updated successfully',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: _errorMessage(e));
      return false;
    }
  }

  Future<bool> createProduct(FormData formData) async {
    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final createdProduct = await repository.createProduct(formData);
      await getProducts();
      state = state.copyWith(
        isSaving: false,
        ownedProductKeys: {
          ...state.ownedProductKeys,
          if (state.myCompany != null)
            _ownedProductKey(state.myCompany!.id, createdProduct.id),
        },
        successMessage: 'Product created successfully',
      );
      await _saveOwnedProductKeys(state.ownedProductKeys);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> updateProduct({
    required String productId,
    required FormData formData,
  }) async {
    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      await repository.updateProduct(productId: productId, formData: formData);
      await getProducts();
      state = state.copyWith(
        isSaving: false,
        successMessage: 'Product updated successfully',
      );
      return true;
    } catch (e) {
      final message = _errorMessage(e);
      state = state.copyWith(
        isSaving: false,
        errorMessage: message,
      );
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      await repository.deleteProduct(productId);
      await getProducts();
      final ownedProductKeys = {...state.ownedProductKeys};
      if (state.myCompany != null) {
        ownedProductKeys.remove(
          _ownedProductKey(state.myCompany!.id, productId),
        );
      }
      state = state.copyWith(
        isSaving: false,
        ownedProductKeys: ownedProductKeys,
        successMessage: 'Product deleted successfully',
      );
      await _saveOwnedProductKeys(state.ownedProductKeys);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            error.message ??
            'Request failed';
      }
      if (data != null) return data.toString();
      return error.message ?? 'Request failed';
    }

    return error.toString().replaceFirst('Exception: ', '');
  }

  String _ownedProductKey(String companyId, String productId) {
    return '${companyId.trim()}:${productId.trim()}';
  }

  Future<void> _loadOwnedProductKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getStringList(_ownedProductKeysPrefsKey) ?? const [];
    state = state.copyWith(ownedProductKeys: keys.toSet());
  }

  Future<void> _saveOwnedProductKeys(Set<String> keys) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_ownedProductKeysPrefsKey, keys.toList());
  }
}
