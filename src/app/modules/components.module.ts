import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';

import { SwiperModule } from 'swiper/angular';

import { RouterModule } from '@angular/router';
import { TranslocoModule } from '@ngneat/transloco';
import { AccountSelectorComponent } from '../components/dialogs/account-selector/account-selector.component';
import { CategoryStatsComponent } from '../components/dialogs/category-stats/category-stats.component';
import { CurrencySelectorComponent } from '../components/dialogs/currency-selector/currency-selector.page';
import { DatePickerComponent } from '../components/dialogs/date-picker/date-picker.component';
import { CustomDateRangeComponent } from '../components/dialogs/date-range-selector/custom-date-range/custom-date-range.component';
import { DateRangeSelectorComponent } from '../components/dialogs/date-range-selector/date-range-selector.component';
import { IconSelectorComponent } from '../components/dialogs/icon-selector/icon-selector.component';
import { TransactionFilterComponent } from '../components/dialogs/transaction-filter/transaction-filter.component';
import { TransactionOrderSelectorComponent } from '../components/dialogs/transaction-order-selector/transaction-order-selector.component';
import { CurrencyValueComponent } from '../components/ui/currency-value/currency-value.component';
import { ProgressBarComponent } from '../components/ui/progress-bar/progress-bar.component';
import { TransactionListComponent } from '../components/ui/transaction-list/transaction-list.component';
import { TrendingComponent } from '../components/ui/trending/trending.component';

@NgModule({
  declarations: [
    CurrencyValueComponent,
    TrendingComponent,
    TransactionListComponent,
    TransactionOrderSelectorComponent,
    TransactionFilterComponent,
    CurrencySelectorComponent,
    CategoryStatsComponent,
    DatePickerComponent,
    DateRangeSelectorComponent,
    CustomDateRangeComponent,
    AccountSelectorComponent,
    IconSelectorComponent,
    ProgressBarComponent,
  ],
  imports: [
    CommonModule,
    TranslocoModule,
    IonicModule,
    RouterModule,
    FormsModule,
    SwiperModule,
  ],
  exports: [
    CurrencyValueComponent,
    TrendingComponent,
    TransactionListComponent,
    ProgressBarComponent,
  ],
})
export class ComponentsModule {}